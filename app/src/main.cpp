#include <iostream>
#include "stdafx.h"

static const char SOURCE_NAME[] = "http://qthttp.apple.com.edgesuite.net/1010qwoeiuryfg/sl.m3u8";

using Pkt = std::unique_ptr<AVPacket, void (*)(AVPacket *)>;
std::deque<Pkt> frame_buffer;
std::mutex frame_mtx;
std::condition_variable frame_cv;
std::atomic_bool keep_running{true};

AVCodecParameters *common_codecpar = nullptr;
std::mutex codecpar_mtx;
std::condition_variable codecpar_cv;

void read_frames_from_source(unsigned N)
{
    AVFormatContext *fmt_ctx = avformat_alloc_context();

    int err = avformat_open_input(&fmt_ctx, SOURCE_NAME, nullptr, nullptr);
    if (err < 0) {
        std::cerr << "cannot open input" << std::endl;
        avformat_free_context(fmt_ctx);
        return;
    }

    err = avformat_find_stream_info(fmt_ctx, nullptr);
    if (err < 0) {
        std::cerr << "cannot find stream info" << std::endl;
        avformat_free_context(fmt_ctx);
        return;
    }

    // Simply finding the first video stream, preferrably H.264. Others are ignored below
    int video_stream_id = -1;
    for (unsigned i = 0; i < fmt_ctx->nb_streams; i++) {
        auto *c = fmt_ctx->streams[i]->codecpar;
        if (c->codec_type == AVMEDIA_TYPE_VIDEO) {
            video_stream_id = i;
            if (c->codec_id == AV_CODEC_ID_H264)
                break;
        }
    }

    if (video_stream_id < 0) {
        std::cerr << "failed to find find video stream" << std::endl;
        avformat_free_context(fmt_ctx);
        return;
    }

    {   // Here we have the codec params and can launch the writer
        std::lock_guard<std::mutex> locker(codecpar_mtx);
        common_codecpar = fmt_ctx->streams[video_stream_id]->codecpar;
    }
    codecpar_cv.notify_all();

    unsigned cnt = 0;
    while (++cnt <= N) { // we read some limited number of frames
        Pkt pkt{av_packet_alloc(), [](AVPacket *p) { av_packet_free(&p); }};

        err = av_read_frame(fmt_ctx, pkt.get());
        if (err < 0) {
            std::cerr << "read packet error" << std::endl;
            continue;
        }

        // That's why the cycle above, we write only one video stream here
        if (pkt->stream_index != video_stream_id)
            continue;

        {
            std::lock_guard<std::mutex> locker(frame_mtx);
            frame_buffer.push_back(std::move(pkt));
        }
        frame_cv.notify_one();
    }

    keep_running.store(false);
    avformat_free_context(fmt_ctx);
}
int main()
{

    std::cout << "OH OH 2" << std::endl;
    return 0;
}