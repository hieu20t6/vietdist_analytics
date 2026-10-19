import os


from dotenv import load_dotenv 

from google.oauth2 import service_account
from googleapiclient.discovery import build
from googleapiclient.http import MediaIoBaseDownload

import io
from pathlib import Path

# Xác định thư mục gốc dự án
BASE_DIR = Path(__file__).resolve().parents[2]

# Đọc file .env ở thư mục gốc
load_dotenv(BASE_DIR / ".env")

# Lấy đường dẫn JSON từ biến môi trường
SERVICE_ACCOUNT_PATH = os.getenv("GOOGLE_SERVICE_ACCOUNT_JSON")

if not SERVICE_ACCOUNT_PATH:
    raise ValueError(
        "Chưa cấu hình GOOGLE_SERVICE_ACCOUNT_JSON trong .env"
    )

# Chuyển đường dẫn thành đối tượng Path
credentials_path = Path(SERVICE_ACCOUNT_PATH)

# Nếu là đường dẫn tương đối, tính từ thư mục gốc
if not credentials_path.is_absolute():
    credentials_path = BASE_DIR / credentials_path

# Kiểm tra file JSON có tồn tại không
if not credentials_path.is_file():
    raise FileNotFoundError(
        f"Không tìm thấy file Service Account JSON"
    )

# Khai báo quyền truy cập Google Drive
SCOPES = ["https://www.googleapis.com/auth/drive.readonly"]

# Tạo đối tượng Credentials
credentials = service_account.Credentials.from_service_account_file(
    str(credentials_path),
    scopes=SCOPES
)

print("Đã tạo Credentials từ Service Account JSON thành công!")

# Hàm kết nối Google Drive
def get_drive_service():
    service = build(
        "drive",
        "v3",
        credentials=credentials
    )

    return service

# Hàm hàm kiểm tra kết nối
def list_files_in_folder(folder_id):
    service = get_drive_service()

    query = f"'{folder_id}' in parents and trashed = false"
    
    response = service.files().list(
        q=query,
        pageSize=1000,
        fields="files(id, name, mimeType, size)"
    ).execute()

    files = response.get("files", [])

    return files

def download_file_as_bytes(file_id):
    service = get_drive_service()

    request = service.files().get_media(fileId=file_id)

    buffer = io.BytesIO()

    downloader = MediaIoBaseDownload(buffer, request)

    done = False 

    while not done:
        status, done = downloader.next_chunk()

    return buffer.getvalue()