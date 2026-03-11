<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Register - Weekly Planner</title>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
            font-family: Arial, sans-serif;
        }

        body {
            min-height: 100vh;
            display: flex;
            justify-content: center;
            align-items: center;
            background: linear-gradient(120deg, #f7c9d4, #d8e8ff);
        }

        .auth-card {
            width: 100%;
            max-width: 460px;
            background: rgba(255, 255, 255, 0.88);
            backdrop-filter: blur(10px);
            border-radius: 24px;
            padding: 35px 30px;
            box-shadow: 0 12px 30px rgba(0, 0, 0, 0.08);
        }

        .title {
            text-align: center;
            font-size: 38px;
            font-weight: 700;
            color: #1f2937;
            margin-bottom: 8px;
        }

        .subtitle {
            text-align: center;
            color: #6b7280;
            margin-bottom: 28px;
            font-size: 15px;
        }

        .message {
            display: none;
            margin-bottom: 16px;
            padding: 12px 14px;
            border-radius: 12px;
            font-size: 14px;
        }

        .message.success {
            background: #dcfce7;
            color: #166534;
        }

        .message.error {
            background: #fee2e2;
            color: #991b1b;
        }

        .input-group {
            margin-bottom: 16px;
        }

        .input-group label {
            display: block;
            margin-bottom: 8px;
            color: #374151;
            font-size: 14px;
            font-weight: 600;
        }

        .input-group input {
            width: 100%;
            padding: 14px 16px;
            border: 1px solid #e5e7eb;
            border-radius: 18px;
            outline: none;
            font-size: 15px;
            background: #f9fafb;
        }

        .input-group input:focus {
            border-color: #f5655b;
            background: #fff;
        }

        .btn {
            width: 100%;
            border: none;
            background: #f5655b;
            color: white;
            padding: 14px;
            border-radius: 18px;
            font-size: 16px;
            font-weight: 700;
            cursor: pointer;
            transition: 0.2s ease;
            margin-top: 8px;
        }

        .btn:hover {
            opacity: 0.92;
            transform: translateY(-1px);
        }

        .footer-text {
            text-align: center;
            margin-top: 18px;
            color: #6b7280;
            font-size: 14px;
        }

        .footer-text a {
            color: #f5655b;
            text-decoration: none;
            font-weight: 700;
        }
    </style>
</head>
<body>
    <div class="auth-card">
        <h1 class="title">Register</h1>
        <p class="subtitle">Buat akun untuk mulai atur minggu kamu</p>

        <div id="messageBox" class="message"></div>

        <form id="registerForm">
            <div class="input-group">
                <label for="name">Nama</label>
                <input type="text" id="name" placeholder="Masukkan nama" required>
            </div>

            <div class="input-group">
                <label for="email">Email</label>
                <input type="email" id="email" placeholder="Masukkan email" required>
            </div>

            <div class="input-group">
                <label for="password">Password</label>
                <input type="password" id="password" placeholder="Masukkan password" required>
            </div>

            <div class="input-group">
                <label for="password_confirmation">Konfirmasi Password</label>
                <input type="password" id="password_confirmation" placeholder="Ulangi password" required>
            </div>

            <button type="submit" class="btn">Register</button>
        </form>

        <p class="footer-text">
            Sudah punya akun? <a href="{{ route('login') }}">Login</a>
        </p>
    </div>

    <script>
        const registerForm = document.getElementById('registerForm');
        const messageBox = document.getElementById('messageBox');

        function showMessage(text, type = 'error') {
            messageBox.style.display = 'block';
            messageBox.className = `message ${type}`;
            messageBox.textContent = text;
        }

        registerForm.addEventListener('submit', async function(e) {
            e.preventDefault();

            const name = document.getElementById('name').value;
            const email = document.getElementById('email').value;
            const password = document.getElementById('password').value;
            const password_confirmation = document.getElementById('password_confirmation').value;

            try {
                const response = await fetch('/api/register', {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/json',
                        'Accept': 'application/json'
                    },
                    body: JSON.stringify({
                        name,
                        email,
                        password,
                        password_confirmation
                    })
                });

                const data = await response.json();

                if (response.ok) {
                    localStorage.setItem('token', data.access_token);
                    showMessage('Register berhasil, mengalihkan...', 'success');
                    setTimeout(() => {
                        window.location.href = '/planner';
                    }, 800);
                } else {
                    if (data.errors) {
                        const firstError = Object.values(data.errors)[0][0];
                        showMessage(firstError);
                    } else {
                        showMessage(data.message || 'Register gagal');
                    }
                }
            } catch (error) {
                showMessage('Terjadi kesalahan saat register');
            }
        });
    </script>
</body>
</html>