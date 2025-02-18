;; Artist Contract

;; Constants
(define-constant contract-owner tx-sender)
(define-constant err-owner-only (err u100))
(define-constant err-not-found (err u101))
(define-constant err-already-registered (err u102))

;; Data Variables
(define-data-var artist-nonce uint u0)

;; Data Maps
(define-map artists
  { artist-id: uint }
  {
    name: (string-ascii 100),
    bio: (string-utf8 1000),
    wallet: principal
  }
)

(define-map artist-songs
  { artist-id: uint }
  { song-ids: (list 100 uint) }
)

;; Public Functions

;; Register a new artist
(define-public (register-artist (name (string-ascii 100)) (bio (string-utf8 1000)))
  (let
    (
      (artist-id (var-get artist-nonce))
    )
    (asserts! (is-none (map-get? artists { artist-id: artist-id })) err-already-registered)
    (map-set artists
      { artist-id: artist-id }
      {
        name: name,
        bio: bio,
        wallet: tx-sender
      }
    )
    (map-set artist-songs
      { artist-id: artist-id }
      { song-ids: (list) }
    )
    (var-set artist-nonce (+ artist-id u1))
    (ok artist-id)
  )
)

;; Update artist profile
(define-public (update-artist-profile (artist-id uint) (name (string-ascii 100)) (bio (string-utf8 1000)))
  (let
    (
      (artist (unwrap! (map-get? artists { artist-id: artist-id }) err-not-found))
    )
    (asserts! (is-eq tx-sender (get wallet artist)) err-owner-only)
    (map-set artists
      { artist-id: artist-id }
      (merge artist { name: name, bio: bio })
    )
    (ok true)
  )
)

;; Add a song to artist's catalog
(define-public (add-song (artist-id uint) (song-id uint))
  (let
    (
      (artist (unwrap! (map-get? artists { artist-id: artist-id }) err-not-found))
      (songs (default-to { song-ids: (list) } (map-get? artist-songs { artist-id: artist-id })))
    )
    (asserts! (is-eq tx-sender (get wallet artist)) err-owner-only)
    (map-set artist-songs
      { artist-id: artist-id }
      { song-ids: (unwrap! (as-max-len? (append (get song-ids songs) song-id) u100) err-owner-only) }
    )
    (ok true)
  )
)

;; Read-only Functions

;; Get artist details
(define-read-only (get-artist (artist-id uint))
  (ok (unwrap! (map-get? artists { artist-id: artist-id }) err-not-found))
)

;; Get artist's songs
(define-read-only (get-artist-songs (artist-id uint))
  (ok (unwrap! (map-get? artist-songs { artist-id: artist-id }) err-not-found))
)

;; Initialize contract
(begin
  (var-set artist-nonce u0)
)

