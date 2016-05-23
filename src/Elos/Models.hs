module Elos.Models where

data Record =
    Action {
        completed :: Bool,
        createdAt :: String,
        endTime :: String,
        id :: String,
        name :: String,
        startTime :: String,
        updatedAt :: String,
        actionable :: [String],
        owner :: [String],
        person :: [String],
        task :: [String]
    } |
    Attribute {
        createdAt :: String,
        deletedAt :: String,
        id :: String,
        updatedAt :: String,
        value :: String,
        object :: [String],
        owner :: [String],
        trait :: [String]
    }

