import { describe, it, expect } from "vitest"

// Mock the Clarity functions and types
const mockClarity = {
  tx: {
    sender: "ST1PQHQKV0RJXZFY1DGX8MNSNYVE3VGZJSRTPGZGM",
  },
  types: {
    uint: (value: number) => ({ type: "uint", value }),
    principal: (value: string) => ({ type: "principal", value }),
    string: (value: string) => ({ type: "string", value }),
    list: (value: any[]) => ({ type: "list", value }),
  },
}

// Mock contract calls
const contractCalls = {
  "register-artist": (name: string, bio: string) => {
    return { success: true, value: mockClarity.types.uint(0) }
  },
  "update-artist-profile": (artistId: number, name: string, bio: string) => {
    return { success: true, value: true }
  },
  "add-song": (artistId: number, songId: number) => {
    return { success: true, value: true }
  },
  "get-artist": (artistId: number) => {
    return {
      success: true,
      value: {
        name: mockClarity.types.string("Artist Name"),
        bio: mockClarity.types.string("Artist Bio"),
        wallet: mockClarity.types.principal("ST1PQHQKV0RJXZFY1DGX8MNSNYVE3VGZJSRTPGZGM"),
      },
    }
  },
  "get-artist-songs": (artistId: number) => {
    return {
      success: true,
      value: {
        "song-ids": mockClarity.types.list([mockClarity.types.uint(1), mockClarity.types.uint(2)]),
      },
    }
  },
}

describe("Artist Contract", () => {
  it("should register a new artist", () => {
    const result = contractCalls["register-artist"]("Artist Name", "Artist Bio")
    expect(result.success).toBe(true)
    expect(result.value).toEqual(mockClarity.types.uint(0))
  })
  
  it("should update an artist's profile", () => {
    const result = contractCalls["update-artist-profile"](0, "Updated Name", "Updated Bio")
    expect(result.success).toBe(true)
    expect(result.value).toBe(true)
  })
  
  it("should add a song to an artist's catalog", () => {
    const result = contractCalls["add-song"](0, 1)
    expect(result.success).toBe(true)
    expect(result.value).toBe(true)
  })
  
  it("should get artist details", () => {
    const result = contractCalls["get-artist"](0)
    expect(result.success).toBe(true)
    expect(result.value).toEqual({
      name: mockClarity.types.string("Artist Name"),
      bio: mockClarity.types.string("Artist Bio"),
      wallet: mockClarity.types.principal("ST1PQHQKV0RJXZFY1DGX8MNSNYVE3VGZJSRTPGZGM"),
    })
  })
  
  it("should get artist's songs", () => {
    const result = contractCalls["get-artist-songs"](0)
    expect(result.success).toBe(true)
    expect(result.value).toEqual({
      "song-ids": mockClarity.types.list([mockClarity.types.uint(1), mockClarity.types.uint(2)]),
    })
  })
})

