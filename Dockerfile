# ---- Giai đoạn 1: Builder ----
# Sử dụng base image slim để build Python dependencies
FROM python:3.9-slim AS builder

WORKDIR /app

# Cài đặt các gói cần thiết cho việc build (nếu requirements.txt cần compile C extensions)
# và git nếu requirements.txt có link git repo.
# Dọn dẹp cache apt ngay lập tức.
# Bạn có thể bỏ 'build-essential' nếu pip install chạy mà không cần nó.
RUN apt-get update && \
    apt-get install -y --no-install-recommends git build-essential && \
    rm -rf /var/lib/apt/lists/*

# Copy chỉ file requirements.txt trước để tận dụng Docker cache
COPY requirements.txt .

# Cài đặt Python dependencies, không dùng cache pip
RUN pip install --upgrade pip && \
    pip install --no-cache-dir -r requirements.txt

# Copy phần còn lại của source code (đã được lọc bởi .dockerignore)
COPY . .

# ---- Giai đoạn 2: Final Image ----
# Bắt đầu lại từ base image slim sạch sẽ
FROM python:3.9-slim

WORKDIR /app

# Cài đặt CHỈ các runtime dependencies cần thiết từ hệ thống: ffmpeg
# Dùng --no-install-recommends và dọn dẹp cache apt
RUN apt-get update && \
    apt-get install -y --no-install-recommends ffmpeg && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Tạo user không phải root để chạy ứng dụng (bảo mật tốt hơn)
RUN useradd --create-home appuser
USER appuser

# Copy Python dependencies đã cài đặt từ giai đoạn builder
# Đường dẫn site-packages có thể thay đổi một chút, nhưng đây là đường dẫn phổ biến
COPY --chown=appuser:appuser --from=builder /usr/local/lib/python3.9/site-packages /usr/local/lib/python3.9/site-packages

# Copy application code từ giai đoạn builder
# Đảm bảo user appuser có quyền sở hữu
COPY --chown=appuser:appuser --from=builder /app /app

# Expose port (cũng được định nghĩa trong docker-compose nhưng để ở đây cũng tốt)
EXPOSE 5000

# Lệnh để chạy ứng dụng Flask (sử dụng biến môi trường từ docker-compose)
CMD ["flask", "run"]
