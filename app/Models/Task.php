<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use App\Models\User;

/**
 * @property int $id
 * @property string $day
 * @property string $time
 * @property int $category_id
 * @property string $title
 * @property bool $is_done
 * @property-read Category $category
 */

class Task extends Model
{
    use HasFactory;

    protected $fillable = ['user_id', 'task_key', 'day', 'time', 'category_id', 'title', 'is_done'];

    public function category()
    {
        return $this->belongsTo(Category::class);
    }
    public function user()
    {
        return $this->belongsTo(User::class);
    }
}
