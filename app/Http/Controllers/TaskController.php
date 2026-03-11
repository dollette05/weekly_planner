<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use App\Models\Task;
use App\Models\Category;
use Illuminate\Support\Str;


class TaskController extends Controller
{
    public function index(Request $request)
    {
        $days = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'];
        $selectedDay = $request->get('day', 'Monday');

        $categories = Category::orderBy('name')->get();

        $tasks = Task::with('category')
            ->where('user_id', auth()->id())
            ->where('day', $selectedDay)
            ->orderBy('time')
            ->get();

        return view('tasks.index', compact('tasks', 'days', 'selectedDay', 'categories'));
    }

    public function create()
    {
        $categories = Category::orderBy('name')->get();
        $days = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'];

        return view('tasks.create', compact('categories', 'days'));
    }

    public function store(Request $request)
    {
        $validated = $request->validate([
            'day' => 'required|string',
            'time' => 'required',
            'category_id' => 'required|exists:categories,id',
            'title' => 'required|string|max:255',
        ]);

        $validated['user_id'] = auth()->id();
        $validated['task_key'] = Str::uuid();

        Task::create($validated);

        return redirect()->route('planner');
    }

    public function show(string $id)
    {
        //
    }

    public function edit(Task $task)
    {
        $categories = Category::orderBy('name')->get();
        $days = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'];

        return view('tasks.edit', compact('task', 'categories', 'days'));
    }

    public function update(Request $request, Task $task)
    {
        // 1) Toggle selesai (untuk tombol cek)
        if ($request->boolean('toggle_done')) {
            // pastikan kamu punya kolom boolean ini di tabel tasks
            $task->is_done = ! (bool) $task->is_done;
            $task->save();

            return back()->with('success', 'Status task diperbarui!');
        }

        $validated = $request->validate([
            'day' => 'required|string',
            'time' => 'required',
            'category_id' => 'required|exists:categories,id',
            'title' => 'required|string|max:255',
        ]);

        $task->update($validated);

        return redirect()->route('planner', ['day' => $validated['day']])
            ->with('success', 'Task berhasil diupdate!');
    }

    public function destroy(Task $task)
    {
        $day = $task->day;
        $task->delete();

        return redirect()->route('planner', ['day' => $task->day])
            ->with('success', 'Task berhasil dihapus!');
    }

    public function toggleDone(Task $task)
    {
        $task->is_done = !$task->is_done;
        $task->save();

        return back();
    }
}
