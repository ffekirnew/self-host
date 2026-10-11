# Intel iGPU usage (intel_gpu_top) served as JSON for the glance dashboard
FROM debian:trixie-slim
RUN apt-get update \
 && apt-get install -y --no-install-recommends intel-gpu-tools python3-minimal \
 && rm -rf /var/lib/apt/lists/*
COPY server.py /server.py
EXPOSE 8080
CMD ["python3", "-u", "/server.py"]
