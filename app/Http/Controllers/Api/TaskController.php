<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Task;
use Illuminate\Http\Request;
use Illuminate\Support\Str;

class TaskController extends Controller
{
    public function index(Request $request)
    {
        $user = auth('api')->user();

        $q = Task::with('category')
            ->where('user_id', $user->id)
            ->orderBy('time');

        if ($request->filled('day')) {
            $q->where('day', $request->day);
        }

        return response()->json($q->get());
    }

    public function store(Request $request)
    {
        $data = $request->validate([
            'day' => 'required|string',
            'time' => 'required|date_format:H:i',
            'category_id' => 'required|integer|exists:categories,id',
            'title' => 'required|string|max:255',
            'is_done' => 'sometimes|boolean',
        ]);

        $data['time'] = $data['time'] . ':00';
        $data['is_done'] = $data['is_done'] ?? false;

        $data['task_key'] = Str::uuid()->toString();
        $data['user_id'] = auth()->id();

        $task = Task::create($data)->load('category');

        return response()->json($task, 201);
    }

    public function show($id)
    {
        $task = Task::with('category')
            ->where('user_id', auth()->id())
            ->findOrFail($id);

        return response()->json($task);
    }

    public function update(Request $request, $id)
    {
        $task = Task::where('user_id', auth()->id())->findOrFail($id);

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

    public function destroy($id)
    {
        $task = Task::where('user_id', auth()->id())->findOrFail($id);

        $task->delete();

        return response()->json(['success' => true]);
    }
}
