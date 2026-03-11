<?php

use Illuminate\Support\Facades\Route;
use Illuminate\Support\Facades\Auth;
use Illuminate\Http\Request;
use App\Http\Controllers\TaskController;

Route::get('/login', function () {
    return view('login');
})->name('login');

Route::post('/login', function (Request $request) {

    $credentials = $request->only('email', 'password');

    if (Auth::attempt($credentials)) {
        $request->session()->regenerate();
        return redirect('/planner');
    }

    return back()->withErrors([
        'email' => 'Email atau password salah'
    ]);
});

Route::get('/register', function () {
    return view('register');
})->name('register');


Route::middleware('auth')->group(function () {

    Route::get('/planner', [TaskController::class, 'index'])->name('planner');

    Route::resource('tasks', TaskController::class)
        ->except(['index','show']);

    Route::patch('/tasks/{task}/toggle-done', [TaskController::class, 'toggleDone'])
        ->name('tasks.toggleDone');

    Route::post('/logout', function () {
        Auth::logout();
        return redirect('/login');
    })->name('logout');

});

Route::get('/', function () {
    return redirect('/planner');
});