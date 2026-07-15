package com.example.snakeapp;

import org.junit.jupiter.api.Test;

import java.util.List;

import static org.junit.jupiter.api.Assertions.assertEquals;

class SnakeGameLogicTest {
    @Test
    void moveShouldAdvanceTheSnakeHead() {
        List<SnakeGameLogic.Point> snake = List.of(
                new SnakeGameLogic.Point(5, 5),
                new SnakeGameLogic.Point(4, 5),
                new SnakeGameLogic.Point(3, 5)
        );

        List<SnakeGameLogic.Point> moved = SnakeGameLogic.move(snake, SnakeGameLogic.Direction.RIGHT);

        assertEquals(List.of(
                new SnakeGameLogic.Point(6, 5),
                new SnakeGameLogic.Point(5, 5),
                new SnakeGameLogic.Point(4, 5)
        ), moved);
    }
}
