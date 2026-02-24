<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

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

    protected $fillable = ['day','time','category_id','title','is_done'];

    public function category()
    {
        return $this->belongsTo(Category::class);
    }
}