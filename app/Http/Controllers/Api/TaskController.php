<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Task;
use Illuminate\Http\Request;

class TaskController extends Controller
{
    /**
     * Display a listing of the resource.
     */
    public function index(Request $request)
    {
        $q = Task::with('category')->orderBy('time');

        if ($request->filled('day')) {
            $q->where('day', $request->day);
        }

        return response()->json($q->get());
    }

    public function store(Request $request)
    {
        $data = $request->validate([
            'day' => 'required|string',
            'time' => 'required|date_format:H:i',        // frontend kirim "11:00"
            'category_id' => 'required|integer|exists:categories,id',
            'title' => 'required|string|max:255',
            'is_done' => 'sometimes|boolean',
        ]);

        // simpan jadi H:i:s biar sama seperti output kamu
        $data['time'] = $data['time'] . ':00';
        $data['is_done'] = $data['is_done'] ?? false;

        $task = Task::create($data)->load('category');

        return response()->json($task, 201);
    }

    /**
     * Display the specified resource.
     */
    public function show(\App\Models\Task $task)
    {
        return response()->json($task->load('category'));
    }

    public function update(Request $request, Task $task)
    {
        $data = $request->validate([
            'day' => 'sometimes|required|string',
            'time' => 'sometimes|required|date_format:H:i',
            'category_id' => 'sometimes|required|integer|exists:categories,id',
            'title' => 'sometimes|required|string|max:255',
            'is_done' => 'sometimes|boolean',
        ]);

        if (isset($data['time'])) {
            $data['time'] = $data['time'] . ':00';
        }

        $task->update($data);

        return response()->json($task->fresh()->load('category'));
    }

    public function destroy(Task $task)
    {
        $task->delete();

        return response()->json(['success' => true]);
    }
}
