@extends('layout')

@section('content')
<h1>Tambah Task</h1>

<form method="POST" action="{{ route('tasks.store') }}">
    @csrf

    <div>
        <label>Hari</label>
        <select name="day">
            @foreach($days as $day)
            <option value="{{ $day }}">{{ $day }}</option>
            @endforeach
        </select>
        @error('day') <div>{{ $message }}</div> @enderror
    </div>

    <div>
        <label>Waktu</label>
        <input type="time" name="time" value="{{ old('time') }}">
        @error('time') <div>{{ $message }}</div> @enderror
    </div>

    <div>
        <label>Kategori</label>
        <select name="category_id">
            @foreach($categories as $cat)
            <option value="{{ $cat->id }}">{{ $cat->name }}</option>
            @endforeach
        </select>
        @error('category_id') <div>{{ $message }}</div> @enderror
    </div>

    <div>
        <label>Judul Kegiatan</label>
        <input type="text" name="title" value="{{ old('title') }}" placeholder="Contoh: Rapat tim">
        @error('title') <div>{{ $message }}</div> @enderror
    </div>

    <br>
    <button class="btn" type="submit">Simpan</button>
    <a class="btn" href="{{ route('tasks.index') }}">Kembali</a>
</form>
@endsection