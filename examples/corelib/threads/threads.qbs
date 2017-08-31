import qbs

Project {
    name: "threads"
    references: [
        "mandelbrot",
        "queuedcustomtype",
        "semaphores",
        "waitconditions",
    ]
}
