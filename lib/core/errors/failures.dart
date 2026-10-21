// ==========================================
// FILE: lib/core/errors/failures.dart
// TẦNG: Core (dùng chung cho toàn bộ app)
// MỤC ĐÍCH: Định nghĩa các loại lỗi (Failure)
//           mà tầng Domain sẽ ném ra cho tầng Presentation.
//           Presentation chỉ thấy "Failure", không biết lỗi đến từ API hay Database.
// ==========================================

import 'package:equatable/equatable.dart';

// Lớp cha trừu tượng - mọi loại lỗi đều kế thừa từ đây
abstract class Failure extends Equatable {
  final String message; // Thông điệp lỗi hiển thị cho người dùng

  const Failure(this.message);

  @override
  List<Object?> get props => [message];
}

// Lỗi khi server trả về mã lỗi (4xx, 5xx)
class ServerFailure extends Failure {
  const ServerFailure([super.message = 'Lỗi kết nối máy chủ. Vui lòng thử lại!']);
}

// Lỗi khi không có kết nối mạng
class NetworkFailure extends Failure {
  const NetworkFailure([super.message = 'Không có kết nối mạng. Kiểm tra Wi-Fi!']);
}

// Lỗi khi không tìm thấy dữ liệu
class NotFoundFailure extends Failure {
  const NotFoundFailure([super.message = 'Không tìm thấy dữ liệu!']);
}
