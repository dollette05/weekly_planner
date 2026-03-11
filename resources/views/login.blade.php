<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Login - Weekly Planner</title>

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
            max-width: 430px;
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
            margin-bottom: 16px;
            padding: 12px 14px;
            border-radius: 12px;
            font-size: 14px;
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
            border-color: #f87171;
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

        <h1 class="title">Login</h1>
        <p class="subtitle">Masuk ke Weekly Planner kamu</p>

        @if($errors->any())
        <div class="message">
            {{ $errors->first() }}
        </div>
        @endif

        <form method="POST" action="/login">
            @csrf

            <div class="input-group">
                <label for="email">Email</label>
                <input type="email" id="email" name="email" placeholder="Masukkan email" required>
            </div>

            <div class="input-group">
                <label for="password">Password</label>
                <input type="password" id="password" name="password" placeholder="Masukkan password" required>
            </div>

            <button type="submit" class="btn">Login</button>

        </form>

        <p class="footer-text">
            Belum punya akun? <a href="{{ route('register') }}">Register</a>
        </p>

    </div>

</body>

</html>