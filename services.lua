--[[
    NX CHEAT ENGINE V4  |  SERVICES
    Centralized game service references.
]]

local Players = game:GetService("Players")

return {
    Players      = Players,
    RS           = game:GetService("ReplicatedStorage"),
    RunService   = game:GetService("RunService"),
    UIS          = game:GetService("UserInputService"),
    TweenService = game:GetService("TweenService"),
    VirtualUser  = game:GetService("VirtualUser"),
    StarterGui   = game:GetService("StarterGui"),
    Workspace    = game:GetService("Workspace"),
    HttpService  = game:GetService("HttpService"),
    Lighting     = game:GetService("Lighting"),
    LP           = Players.LocalPlayer,
}
