{-# LANGUAGE ApplicativeDo #-}

fail_if :: (a -> Bool) -> a -> Maybe a
fail_if f x | (f x)     = Nothing
            | otherwise = Just x

-- Fails if it recieves a nice greeting, or a greeting
-- has too many excalmation points
dont_greet_me :: String -> Maybe String
dont_greet_me s = do
    fail_if (== "howdy") s
    fail_if (== "good morning") s
    fail_if (== "how are you?") s
    l <- pure length <*> (pure (filter (== '!')) <*> (pure s))
    -- You can use l like it was an integer here!
    fail_if (> 3) l
    pure s
