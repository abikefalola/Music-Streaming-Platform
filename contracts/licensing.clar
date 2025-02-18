;; Licensing Contract

;; Constants
(define-constant contract-owner tx-sender)
(define-constant err-owner-only (err u100))
(define-constant err-not-found (err u101))
(define-constant err-unauthorized (err u102))

;; Data Variables
(define-data-var license-nonce uint u0)

;; Data Maps
(define-map licenses
  { license-id: uint }
  {
    song-id: uint,
    artist-id: uint,
    price: uint,
    royalty-rate: uint,
    active: bool
  }
)

(define-map royalties
  { artist-id: uint }
  { balance: uint }
)

;; Public Functions

;; Create a new license
(define-public (create-license (song-id uint) (artist-id uint) (price uint) (royalty-rate uint))
  (let
    (
      (license-id (var-get license-nonce))
    )
    (asserts! (is-eq tx-sender contract-owner) err-owner-only)
    (map-set licenses
      { license-id: license-id }
      {
        song-id: song-id,
        artist-id: artist-id,
        price: price,
        royalty-rate: royalty-rate,
        active: true
      }
    )
    (var-set license-nonce (+ license-id u1))
    (ok license-id)
  )
)

;; Update license details
(define-public (update-license (license-id uint) (price uint) (royalty-rate uint) (active bool))
  (let
    (
      (license (unwrap! (map-get? licenses { license-id: license-id }) err-not-found))
    )
    (asserts! (is-eq tx-sender contract-owner) err-owner-only)
    (map-set licenses
      { license-id: license-id }
      (merge license { price: price, royalty-rate: royalty-rate, active: active })
    )
    (ok true)
  )
)

;; Purchase a license
(define-public (purchase-license (license-id uint))
  (let
    (
      (license (unwrap! (map-get? licenses { license-id: license-id }) err-not-found))
      (artist-royalties (default-to { balance: u0 } (map-get? royalties { artist-id: (get artist-id license) })))
    )
    (asserts! (get active license) err-unauthorized)
    (try! (stx-transfer? (get price license) tx-sender (as-contract tx-sender)))
    (map-set royalties
      { artist-id: (get artist-id license) }
      { balance: (+ (get balance artist-royalties) (/ (* (get price license) (get royalty-rate license)) u100)) }
    )
    (ok true)
  )
)

;; Withdraw royalties
(define-public (withdraw-royalties (artist-id uint))
  (let
    (
      (artist-royalties (unwrap! (map-get? royalties { artist-id: artist-id }) err-not-found))
    )
    (asserts! (> (get balance artist-royalties) u0) err-unauthorized)
    (try! (as-contract (stx-transfer? (get balance artist-royalties) tx-sender (unwrap! (contract-call? .artist get-artist artist-id) err-not-found))))
    (map-set royalties
      { artist-id: artist-id }
      { balance: u0 }
    )
    (ok true)
  )
)

;; Read-only Functions

;; Get license details
(define-read-only (get-license (license-id uint))
  (ok (unwrap! (map-get? licenses { license-id: license-id }) err-not-found))
)

;; Get artist royalties
(define-read-only (get-royalties (artist-id uint))
  (ok (unwrap! (map-get? royalties { artist-id: artist-id }) err-not-found))
)

;; Initialize contract
(begin
  (var-set license-nonce u0)
)

