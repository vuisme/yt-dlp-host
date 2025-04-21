import os

# File system
DOWNLOAD_DIR = os.getenv('DOWNLOAD_DIR', '/app/downloads')
TASKS_FILE = os.getenv('TASKS_FILE', 'jsons/tasks.json')
KEYS_FILE = os.getenv('KEYS_FILE', 'jsons/api_keys.json')

# Task management
TASK_CLEANUP_TIME = int(os.getenv('TASK_CLEANUP_TIME', 10))  # minutes
REQUEST_LIMIT = int(os.getenv('REQUEST_LIMIT', 60))  # per TASK_CLEANUP_TIME
MAX_WORKERS = int(os.getenv('MAX_WORKERS', 4))

# API key settings
DEFAULT_MEMORY_QUOTA = int(os.getenv('DEFAULT_MEMORY_QUOTA', 5 * 1024 * 1024 * 1024))  # 5GB
DEFAULT_MEMORY_QUOTA_RATE = int(os.getenv('DEFAULT_MEMORY_QUOTA_RATE', 10))  # minutes

# Memory control
SIZE_ESTIMATION_BUFFER = float(os.getenv('SIZE_ESTIMATION_BUFFER', 1.10))
AVAILABLE_MEMORY = int(os.getenv('AVAILABLE_MEMORY', 20 * 1024 * 1024 * 1024))  # 20GB
