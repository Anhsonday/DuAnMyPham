<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<html>
<head>
    <title>Sửa đánh giá sản phẩm</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/bootstrap.min.css" />
</head>
<body>
    <div class="container mt-4">
        <h2>Sửa đánh giá sản phẩm</h2>
        <form action="${pageContext.request.contextPath}/review/edit" method="post">
            <input type="hidden" name="reviewId" value="${review.reviewId}" />
            <div class="mb-3">
                <label for="rating" class="form-label">Đánh giá (số sao):</label>
                <select name="rating" id="rating" class="form-select" required>
                    <c:forEach var="i" begin="1" end="5">
                        <option value="${i}" ${review.rating == i ? 'selected' : ''}>${i} ★</option>
                    </c:forEach>
                </select>
            </div>
            <div class="mb-3">
                <label for="comment" class="form-label">Bình luận:</label>
                <textarea name="comment" id="comment" class="form-control" rows="4" required>${review.comment}</textarea>
            </div>
            <div class="mb-3">
                <label for="skinCondition" class="form-label">Tình trạng sau khi sử dụng:</label>
                <textarea name="skinCondition" id="skinCondition" class="form-control" rows="2">${review.skinCondition}</textarea>
            </div>
            <button type="submit" class="btn btn-primary">Lưu thay đổi</button>
            <a href="${pageContext.request.contextPath}/product-detail?id=${review.productId.productId}#tab_3rd" class="btn btn-secondary">Huỷ</a>
        </form>
    </div>
</body>
</html> 