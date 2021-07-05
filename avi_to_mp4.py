import ffmpy

ff = ffmpy.FFmpeg(
inputs={'./results/Detection_results.avi': None},
outputs={'./results/Detection_results.mp4': None}
)
ff.run()


        