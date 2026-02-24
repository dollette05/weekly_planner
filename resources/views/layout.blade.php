<!doctype html>
<html lang="id">
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Weekly Planner</title>

    @vite(['resources/css/app.css','resources/js/app.js'])
</head>

<body>
    @if(session('success'))
        <div class="toast success">{{ session('success') }}</div>
    @endif

    @if ($errors->any())
        <div class="toast error">
            <ul>
                @foreach ($errors->all() as $error)
                    <li>{{ $error }}</li>
                @endforeach
            </ul>
        </div>
    @endif

    @yield('content')
</body>
</html>