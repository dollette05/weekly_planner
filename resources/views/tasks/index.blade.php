@extends('layout')

@section('content')
@php
$name = auth()->user()->name ?? 'Teman';
$selectedDay = request('day', 'Monday');
@endphp

<div class="page">
    <div class="card">
        <div class="topbar">
            <div class="hello">
                <span class="hello-muted">Hello,</span>
                <span class="hello-name">{{ $name }}</span>
                <span id="greeting" class="hello-greet">Good Day!</span>
            </div>

            <div class="clock">
                <span class="clock-label">Time:</span>
                <span id="clock" class="clock-time">--:--:--</span>
            </div>
        </div>

        <div class="title">
            <h1>Weekly Planner</h1>
            <div class="title-icon" aria-hidden="true">🗓️</div>
        </div>

        {{-- Form tambah task: sejajar 1 baris --}}
        <form class="addbar addbar-row" method="POST" action="{{ route('tasks.store') }}">
            @csrf

            <select id="dayPicker" name="day" class="addbar-input addbar-select" required>
                @foreach($days as $d)
                <option value="{{ $d }}" {{ $selectedDay === $d ? 'selected' : '' }}>
                    {{ $d }}
                </option>
                @endforeach
            </select>

            <input class="addbar-input" type="time" name="time" required>

            <select class="addbar-input addbar-select" name="category_id" required>
                <option value="">Pilih kategori</option>
                @foreach($categories as $cat)
                <option value="{{ $cat->id }}">{{ $cat->name }}</option>
                @endforeach
            </select>

            <input
                class="addbar-input"
                type="text"
                name="title"
                placeholder="Tambah kegiatan / task"
                autocomplete="off"
                required>

            <button class="addbar-btn" type="submit">Add</button>
        </form>

        <script>
            document.getElementById('dayPicker')?.addEventListener('change', function() {
                const url = new URL(window.location.href);
                url.searchParams.set('day', this.value);
                window.location.href = url.toString();
            });
        </script>

        <div class="list">
            @forelse($tasks as $task)
            <div class="todo {{ $task->is_done ? 'is-done' : '' }}">
                {{-- Toggle done --}}
                <form method="POST" action="{{ route('tasks.update', $task->id) }}" class="todo-left">
                    @csrf
                    @method('PATCH')
                    <input type="hidden" name="toggle_done" value="1">
                    <button class="todo-check" type="submit" aria-label="Toggle done">
                        <span class="dot"></span>
                    </button>
                </form>

                <div class="todo-text">
                    <div class="todo-row">
                        <span class="todo-time">{{ \Carbon\Carbon::parse($task->time)->format('H:i') }}</span>
                        <span class="todo-title">{{ $task->title }}</span>
                    </div>
                    <div class="todo-meta">
                        <span class="pill">{{ $task->day }}</span>
                        <span class="pill">{{ $task->category->name ?? 'No Category' }}</span>
                    </div>
                </div>

                

                {{-- Delete --}}
                <form method="POST" action="{{ route('tasks.destroy', $task->id) }}" class="todo-right">
                    @csrf
                    @method('DELETE')
                    <button class="todo-trash" type="submit" aria-label="Delete task">
                        <svg width="18" height="18" viewBox="0 0 24 24" fill="none">
                            <path d="M9 3h6m-8 4h10m-9 0 1 16h6l1-16" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" />
                            <path d="M10 11v7M14 11v7" stroke="currentColor" stroke-width="2" stroke-linecap="round" />
                        </svg>
                    </button>
                </form>
            </div>
            @empty
            <div class="empty">
                Belum ada task. Tambahin yang pertama yuk 👇
            </div>
            @endforelse
        </div>
    </div>
</div>
@endsection