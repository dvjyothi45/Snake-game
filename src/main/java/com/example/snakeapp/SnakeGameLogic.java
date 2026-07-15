package com.example.snakeapp;

import java.util.ArrayList;
import java.util.List;

public class SnakeGameLogic {
    public enum Direction {
        UP,
        RIGHT,
        DOWN,
        LEFT
    }

    public record Point(int x, int y) {
    }

    public static List<Point> move(List<Point> snake, Direction direction) {
        List<Point> nextSnake = new ArrayList<>();
        Point head = snake.get(0);
        Point nextHead = switch (direction) {
            case UP -> new Point(head.x(), head.y() - 1);
            case DOWN -> new Point(head.x(), head.y() + 1);
            case LEFT -> new Point(head.x() - 1, head.y());
            case RIGHT -> new Point(head.x() + 1, head.y());
        };

        nextSnake.add(nextHead);
        for (int i = 0; i < snake.size() - 1; i++) {
            nextSnake.add(snake.get(i));
        }
        return nextSnake;
    }
}
