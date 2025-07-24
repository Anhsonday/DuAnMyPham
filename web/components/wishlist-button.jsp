<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<button type="button" class="btn-wishlist" onclick="toggleWishlist(${param.productId})" 
        data-product-id="${param.productId}">
    <i class="fa fa-heart${param.inWishlist ? '' : '-o'}"></i>
    <span class="wishlist-text">
        ${param.inWishlist ? 'Đã thích' : 'Yêu thích'}
    </span>
</button>

<script>
function toggleWishlist(productId) {
    if (!productId) return;
    
    fetch('${pageContext.request.contextPath}/wishlist/toggle', {
        method: 'POST',
        headers: {
            'Content-Type': 'application/x-www-form-urlencoded',
            'X-Requested-With': 'XMLHttpRequest'
        },
        body: `productId=${productId}`
    })
    .then(response => response.json())
    .then(data => {
        if (data.success) {
            // Update button state
            const btn = document.querySelector(`.btn-wishlist[data-product-id="${productId}"]`);
            const icon = btn.querySelector('i');
            const text = btn.querySelector('.wishlist-text');
            
            icon.className = `fa fa-heart${data.inWishlist ? '' : '-o'}`;
            text.textContent = data.inWishlist ? 'Đã thích' : 'Yêu thích';
            
            // Update wishlist count in header using the function from header.jsp
            if (typeof updateWishlistCountBadge === 'function') {
                updateWishlistCountBadge(data.count);
            } else {
                // Fallback if function not available
                const countBadge = document.querySelector('.wishlist-count-badge');
                if (countBadge) {
                    countBadge.textContent = data.count;
                    countBadge.style.display = data.count > 0 ? 'inline-block' : 'none';
                }
            }
            
            // Show notification
            if (typeof showAlert === 'function') {
                showAlert(data.message);
            }
            
            // Refresh wishlist if we're on the wishlist page
            if (typeof refreshWishlist === 'function') {
                refreshWishlist();
            }
        }
    })
    .catch(error => {
        console.error('Error:', error);
        if (typeof showAlert === 'function') {
            showAlert('Có lỗi xảy ra. Vui lòng thử lại sau.', 'danger');
        }
    });
}
</script>

<style>
.btn-wishlist {
    background: none;
    border: none;
    color: #e74c3c;
    cursor: pointer;
    padding: 5px 10px;
    transition: all 0.3s ease;
}

.btn-wishlist:hover {
    color: #c0392b;
}

.btn-wishlist i {
    margin-right: 5px;
}
</style>
