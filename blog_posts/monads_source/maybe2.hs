instance Applicative Maybe where
    pure x = Just x

    -- Written verbosely: notice the similarity
    -- to the short-circuiting boolean OR
    (Just f) <*> (Just x) = Just (f x)
    Nothing  <*> (Just x) = Nothing
    (Just f) <*> Nothing  = Nothing
    Nothing  <*> Nothing  = Nothing
