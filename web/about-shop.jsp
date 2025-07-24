<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Beauty Bloom - Vẻ đẹp tự nhiên</title>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: 'Georgia', 'Times New Roman', serif;
            line-height: 1.6;
            color: #333;
            background: linear-gradient(135deg, #ffeef8 0%, #fff5f8 50%, #f8e8f0 100%);
            overflow-x: hidden;
        }

        .content-fit {
            max-width: 1200px;
            margin: 0 auto;
            padding: 0 20px;
        }

        /* Header */
        header {
            position: fixed;
            top: 0;
            width: 100%;
            background: rgba(255, 255, 255, 0.95);
            backdrop-filter: blur(10px);
            z-index: 1000;
            padding: 15px 0;
            box-shadow: 0 2px 20px rgba(0, 0, 0, 0.1);
            transition: all 0.3s ease;
        }

        header .content-fit {
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        .logo {
            font-size: 2.5rem;
            font-weight: bold;
            background: linear-gradient(45deg, #e91e63, #f06292, #ff7043);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            background-clip: text;
            text-shadow: 2px 2px 4px rgba(0, 0, 0, 0.1);
            transition: transform 0.3s ease;
        }

        .logo:hover {
            transform: scale(1.05);
        }

        nav ul {
            display: flex;
            list-style: none;
            gap: 30px;
        }

        nav li {
            font-size: 1.1rem;
            cursor: pointer;
            padding: 10px 20px;
            border-radius: 25px;
            transition: all 0.3s ease;
            color: #666;
            position: relative;
            overflow: hidden;
        }

        nav li::before {
            content: '';
            position: absolute;
            top: 0;
            left: -100%;
            width: 100%;
            height: 100%;
            background: linear-gradient(45deg, #e91e63, #f06292);
            transition: left 0.3s ease;
            z-index: -1;
        }

        nav li:hover::before {
            left: 0;
        }

        nav li:hover {
            color: white;
            transform: translateY(-2px);
        }

        /* Sections */
        .section {
            min-height: 100vh;
            position: relative;
            display: flex;
            align-items: center;
            padding: 100px 0;
            overflow: hidden;
        }

        .decorate {
            position: absolute;
            opacity: 0.6;
            z-index: -1;
            animation: float 6s ease-in-out infinite;
        }

        @keyframes float {
            0%, 100% { transform: translateY(0px) rotate(0deg); }
            50% { transform: translateY(-20px) rotate(5deg); }
        }

        .number {
            position: absolute;
            font-size: 12rem;
            font-weight: bold;
            color: rgba(233, 30, 99, 0.1);
            left: -50px;
            top: 50px;
            z-index: -1;
            animation: pulse 4s ease-in-out infinite;
        }

        @keyframes pulse {
            0%, 100% { transform: scale(1); }
            50% { transform: scale(1.05); }
        }

        /* Banner */
        #banner {
            background: linear-gradient(135deg, #ff9a9e 0%, #fecfef 50%, #fecfef 100%);
            position: relative;
            overflow: hidden;
        }

        #banner::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            bottom: 0;
            background: url('https://images.unsplash.com/photo-1596462502278-27bfdc403348?ixlib=rb-4.0.3&auto=format&fit=crop&w=2070&q=80') center/cover;
            opacity: 0.3;
            z-index: -2;
        }

        .title {
            font-size: 4rem;
            font-weight: bold;
            text-align: center;
            color: white;
            text-shadow: 2px 2px 4px rgba(0, 0, 0, 0.3);
            position: relative;
            animation: slideInUp 1s ease-out;
        }

        @keyframes slideInUp {
            from {
                opacity: 0;
                transform: translateY(100px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }

        /* Intro Section */
        #intro {
            background: linear-gradient(135deg, #fff5f8 0%, #ffeef8 100%);
            position: relative;
        }

        #intro::before {
            content: '';
            position: absolute;
            right: 0;
            top: 0;
            width: 50%;
            height: 100%;
            background: url('https://images.unsplash.com/photo-1522338242992-e1a54906a8da?ixlib=rb-4.0.3&auto=format&fit=crop&w=1000&q=80') center/cover;
            border-radius: 50px 0 0 50px;
            opacity: 0.8;
        }

        .des {
            max-width: 50%;
            z-index: 10;
            position: relative;
        }

        .des .title {
            font-size: 3rem;
            color: #e91e63;
            margin-bottom: 30px;
            text-align: left;
            animation: fadeInLeft 1s ease-out;
        }

        @keyframes fadeInLeft {
            from {
                opacity: 0;
                transform: translateX(-50px);
            }
            to {
                opacity: 1;
                transform: translateX(0);
            }
        }

        .des p {
            font-size: 1.2rem;
            line-height: 1.8;
            color: #555;
            background: rgba(255, 255, 255, 0.9);
            padding: 30px;
            border-radius: 15px;
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.1);
            animation: fadeInUp 1s ease-out 0.3s both;
        }

        @keyframes fadeInUp {
            from {
                opacity: 0;
                transform: translateY(30px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }

        /* Description Section */
        #description {
            background: linear-gradient(135deg, #f8e8f0 0%, #fff5f8 100%);
            position: relative;
        }

        #description::before {
            content: '';
            position: absolute;
            left: 0;
            top: 0;
            width: 50%;
            height: 100%;
            background: url('https://images.unsplash.com/photo-1571019613454-1cb2f99b2d8b?ixlib=rb-4.0.3&auto=format&fit=crop&w=1000&q=80') center/cover;
            border-radius: 0 50px 50px 0;
            opacity: 0.8;
        }

        #description .des {
            max-width: 50%;
            margin-left: auto;
        }

        /* Products Grid */
        .products-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            gap: 30px;
            margin-top: 50px;
        }

        .product-card {
            background: rgba(255, 255, 255, 0.9);
            border-radius: 20px;
            padding: 20px;
            text-align: center;
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.1);
            transition: all 0.3s ease;
            position: relative;
            overflow: hidden;
        }

        .product-card::before {
            content: '';
            position: absolute;
            top: -50%;
            left: -50%;
            width: 200%;
            height: 200%;
            background: linear-gradient(45deg, transparent, rgba(233, 30, 99, 0.1), transparent);
            transform: rotate(45deg);
            transition: all 0.6s;
            opacity: 0;
        }

        .product-card:hover::before {
            animation: shimmer 0.6s ease-in-out;
        }

        @keyframes shimmer {
            0% {
                transform: translateX(-100%) translateY(-100%) rotate(45deg);
                opacity: 0;
            }
            50% {
                opacity: 1;
            }
            100% {
                transform: translateX(100%) translateY(100%) rotate(45deg);
                opacity: 0;
            }
        }

        .product-card:hover {
            transform: translateY(-10px);
            box-shadow: 0 20px 40px rgba(0, 0, 0, 0.15);
        }

        .product-card img {
            width: 100px;
            height: 100px;
            border-radius: 50%;
            object-fit: cover;
            margin-bottom: 15px;
            border: 3px solid #e91e63;
        }

        .product-card h3 {
            color: #e91e63;
            margin-bottom: 10px;
            font-size: 1.3rem;
        }

        .product-card p {
            color: #666;
            font-size: 0.9rem;
        }

        /* Contact Section */
        #contact {
            background: linear-gradient(135deg, #ffeef8 0%, #f8e8f0 100%);
            position: relative;
        }

        #contact::before {
            content: '';
            position: absolute;
            top: 50%;
            left: 50%;
            transform: translate(-50%, -50%);
            width: 80%;
            height: 80%;
            background: url('https://images.unsplash.com/photo-1560472354-b33ff0c44a43?ixlib=rb-4.0.3&auto=format&fit=crop&w=1926&q=80') center/cover;
            border-radius: 30px;
            opacity: 0.1;
            z-index: -1;
        }

        table {
            width: 100%;
            border-collapse: collapse;
            background: rgba(255, 255, 255, 0.9);
            border-radius: 15px;
            overflow: hidden;
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.1);
        }

        table td {
            padding: 20px;
            border-bottom: 1px solid rgba(233, 30, 99, 0.1);
            font-size: 1.1rem;
        }

        table td:first-child {
            font-weight: bold;
            color: #e91e63;
            width: 200px;
        }

        table td:last-child {
            color: #555;
        }

        table tr:hover {
            background: rgba(233, 30, 99, 0.05);
        }

        .sign {
            text-align: center;
            font-size: 1.5rem;
            font-weight: bold;
            margin-top: 30px;
            color: #e91e63;
            padding: 20px;
            background: rgba(255, 255, 255, 0.9);
            border-radius: 15px;
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.1);
            position: relative;
        }

        .sign::before,
        .sign::after {
            content: '✨';
            position: absolute;
            font-size: 2rem;
            color: #ff7043;
            animation: twinkle 2s ease-in-out infinite;
        }

        .sign::before {
            left: 20px;
        }

        .sign::after {
            right: 20px;
            animation-delay: 1s;
        }

        @keyframes twinkle {
            0%, 100% { opacity: 0.5; transform: scale(1); }
            50% { opacity: 1; transform: scale(1.2); }
        }

        /* Responsive */
        @media (max-width: 768px) {
            .title {
                font-size: 2.5rem;
            }
            
            .des .title {
                font-size: 2rem;
            }
            
            .des {
                max-width: 100%;
            }
            
            #intro::before,
            #description::before {
                display: none;
            }
            
            nav ul {
                gap: 15px;
            }
            
            nav li {
                padding: 8px 15px;
                font-size: 1rem;
            }
            
            .number {
                font-size: 8rem;
            }
        }
        nav ul li a {
            text-decoration: none;
        }
    </style>
</head>
<body>
    <header>
        <div class="content-fit">
            <div class="logo">Beauty Bloom</div>
            <nav>
                <ul>
                    <li class="menu-item"><a href="home">Home</a></li>
                    <li class="menu-item"><a href="contact_us.jsp">Liên hệ</a></li>
                    <li class="menu-item"><a href="all-products">Sản phẩm</a></li>
                    <li class="menu-item"><a href="login">Đăng nhập</a></li>
                </ul>
            </nav>
        </div>
    </header>
    
    <div class="section" id="banner">
        <div class="content-fit">
            <div class="title">Khám phá vẻ đẹp tự nhiên của bạn!</div>
        </div>
    </div>
    
    <div class="section" id="intro">
        <div class="content-fit">
            <div class="number">01</div>
            <div class="des">
                <div class="title">Về Beauty Bloom</div>
                <p>
                    Beauty Bloom là điểm đến lý tưởng cho những ai yêu thích làm đẹp và chăm sóc bản thân. Chúng tôi chuyên cung cấp các sản phẩm mỹ phẩm cao cấp từ những thương hiệu uy tín hàng đầu thế giới, bao gồm sản phẩm chăm sóc da, tóc, cơ thể và nước hoa. Với đội ngũ tư vấn chuyên nghiệp, Beauty Bloom cam kết mang đến cho bạn những trải nghiệm làm đẹp tuyệt vời nhất, giúp bạn tự tin tỏa sáng mỗi ngày.
                </p>
                
                <div class="products-grid">
                    <div class="product-card">
                        <img src="https://dep.com.vn/wp-content/uploads/2021/03/sua-rua-mat-da-mun-5.jpg" alt="Chăm sóc da">
                        <h3>Chăm sóc da</h3>
                        <p>Serum, kem dưỡng, mặt nạ cao cấp cho mọi loại da</p>
                    </div>
                    <div class="product-card">
                        <img src="https://images.unsplash.com/photo-1522338242992-e1a54906a8da?ixlib=rb-4.0.3&auto=format&fit=crop&w=300&q=80" alt="Chăm sóc tóc">
                        <h3>Chăm sóc tóc</h3>
                        <p>Dầu gội, dầu xả, serum dưỡng tóc chuyên nghiệp</p>
                    </div>
                    <div class="product-card">
                        <img src="https://media.tripmap.vn/marketplace/2025/07/c552ecfc1fecc1e0873f5be1e4b04a3e-1.webp" alt="Chăm sóc cơ thể">
                        <h3>Chăm sóc cơ thể</h3>
                        <p>Sữa tắm, kem dưỡng thể, tẩy tế bào chết</p>
                    </div>
                    <div class="product-card">
                        <img src="https://images.unsplash.com/photo-1541643600914-78b084683601?ixlib=rb-4.0.3&auto=format&fit=crop&w=300&q=80" alt="Nước hoa">
                        <h3>Nước hoa</h3>
                        <p>Nước hoa cao cấp từ các thương hiệu nổi tiếng</p>
                    </div>
                </div>
            </div>
        </div>
    </div>
    
    <div class="section" id="description">
        <div class="content-fit">
            <div class="number">02</div>
            <div class="des">
                <div class="title">Tại sao lựa chọn chúng tôi?</div>
                <p>
                    Đến với Beauty Bloom, bạn không chỉ nhận được những sản phẩm mỹ phẩm chính hãng, chất lượng cao mà còn được trải nghiệm dịch vụ tư vấn chuyên nghiệp, tận tâm. Chúng tôi hiểu rằng mỗi người đều có nhu cầu làm đẹp riêng biệt, vì vậy đội ngũ chuyên gia của chúng tôi luôn sẵn sàng tư vấn để giúp bạn lựa chọn những sản phẩm phù hợp nhất với loại da và phong cách của bạn. Hãy để Beauty Bloom đồng hành cùng bạn trên hành trình khám phá và tôn vinh vẻ đẹp tự nhiên!
                </p>
            </div>
        </div>
    </div>
    
    <div class="section" id="contact">
        <div class="content-fit">
            <div class="number">03</div>
            <div class="des">
                <div class="title">Thông tin liên hệ</div>
                <table>
                    <tr>
                        <td>Email:</td>
                        <td>beautybloom@gmail.com</td>
                    </tr>
                    <tr>
                        <td>Số điện thoại:</td>
                        <td>+84 079 657 0060</td>
                    </tr>
                    <tr>
                        <td>Website:</td>
                        <td>www.beautybloom.vn</td>
                    </tr>
                    <tr>
                        <td>Fanpage:</td>
                        <td>facebook.com/beautybloom.vn</td>
                    </tr>
                    <tr>
                        <td>Địa chỉ:</td>
                        <td>123 Đường Nam Kì Khởi Nghĩa, Phường Ngũ Hành Sơn, TP.Đà Nẵng</td>
                    </tr>
                </table>
                <div class="sign">Beauty Bloom – Tỏa sáng vẻ đẹp tự nhiên</div>
            </div>
        </div>
    </div>

    <script>
        // Smooth scrolling animation
        window.addEventListener('scroll', function() {
            const header = document.querySelector('header');
            if (window.scrollY > 100) {
                header.style.background = 'rgba(255, 255, 255, 0.98)';
                header.style.boxShadow = '0 4px 30px rgba(0, 0, 0, 0.15)';
            } else {
                header.style.background = 'rgba(255, 255, 255, 0.95)';
                header.style.boxShadow = '0 2px 20px rgba(0, 0, 0, 0.1)';
            }
        });

        // Add hover effects to product cards
        document.querySelectorAll('.product-card').forEach(card => {
            card.addEventListener('mouseenter', function() {
                this.style.transform = 'translateY(-10px) scale(1.02)';
            });
            
            card.addEventListener('mouseleave', function() {
                this.style.transform = 'translateY(0) scale(1)';
            });
        });

        // Navigation click effects
        document.querySelectorAll('nav li').forEach(item => {
            item.addEventListener('click', function() {
                this.style.transform = 'scale(0.95)';
                setTimeout(() => {
                    this.style.transform = 'scale(1)';
                }, 100);
            });
        });

        // Parallax effect for sections
        window.addEventListener('scroll', function() {
            const scrolled = window.pageYOffset;
            const parallax = document.querySelectorAll('.decorate');
            const speed = 0.5;

            parallax.forEach(element => {
                const yPos = -(scrolled * speed);
                element.style.transform = `translateY(${yPos}px)`;
            });
        });
    </script>
</body>
</html>