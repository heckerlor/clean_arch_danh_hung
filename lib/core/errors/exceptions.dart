// ==========================================
// FILE: lib/core/errors/exceptions.dart
// TẦNG: Core (dùng chung)
// MỤC ĐÍCH: Định nghĩa các Exception phát sinh ở tầng Data.
//           Exception là "lỗi kỹ thuật cụ thể" (ví dụ: HTTP 500).
//           Repository sẽ bắt Exception và chuyển thành Failure
//           trước khi trả lên tầng Domain/Presentation.
// ==========================================

// Exception khi Server trả về lỗi HTTP
class ServerException implements Exception {
  final String message;

  ServerException([this.message = 'Server trả về lỗi không mong muốn']);
}
