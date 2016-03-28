// BranchMiddleware.swift
//
// The MIT License (MIT)
//
// Copyright (c) 2015 Zewo
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.

@_exported import S4

public struct BranchMiddleware: Middleware {
    let condition: Request throws -> Bool
    let truthy: [Middleware]
    let falsy: [Middleware]

    public init(if condition: Request throws -> Bool, branchTo truthy: [Middleware], else falsy: [Middleware] = []) {
        self.condition = condition
        self.truthy = truthy
        self.falsy = falsy
    }

    public init(branchTo truthy: [Middleware], else falsy: [Middleware] = [], if condition: Request throws -> Bool) {
        self.condition = condition
        self.truthy = truthy
        self.falsy = falsy
    }

    public func respond(request: Request, chain: Responder) throws -> Response {
        if try condition(request) {
            return try truthy.intercept(chain).respond(request)
        } else {
            return try falsy.intercept(chain).respond(request)
        }
    }
}

