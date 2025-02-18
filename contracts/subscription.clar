;; Subscription Contract

;; Constants
(define-constant contract-owner tx-sender)
(define-constant err-owner-only (err u100))
(define-constant err-not-found (err u101))
(define-constant err-unauthorized (err u102))

;; Data Variables
(define-data-var subscription-price uint u10) ;; Price in STX tokens

;; Data Maps
(define-map subscriptions
  { user: principal }
  { expiration: uint }
)

;; Public Functions

;; Set subscription price
(define-public (set-subscription-price (new-price uint))
  (begin
    (asserts! (is-eq tx-sender contract-owner) err-owner-only)
    (var-set subscription-price new-price)
    (ok true)
  )
)

;; Purchase a subscription
(define-public (purchase-subscription (duration uint))
  (let
    (
      (total-price (* (var-get subscription-price) duration))
      (current-time block-height)
      (expiration (+ current-time (* duration u144))) ;; Assuming 144 blocks per day
      (current-subscription (default-to { expiration: u0 } (map-get? subscriptions { user: tx-sender })))
    )
    (try! (stx-transfer? total-price tx-sender (as-contract tx-sender)))
    (map-set subscriptions
      { user: tx-sender }
      { expiration: (if (> (get expiration current-subscription) current-time)
                        (+ (get expiration current-subscription) (* duration u144))
                        expiration) }
    )
    (ok true)
  )
)

;; Cancel a subscription
(define-public (cancel-subscription)
  (begin
    (map-delete subscriptions { user: tx-sender })
    (ok true)
  )
)

;; Read-only Functions

;; Get subscription status
(define-read-only (get-subscription-status (user principal))
  (let
    (
      (subscription (default-to { expiration: u0 } (map-get? subscriptions { user: user })))
    )
    (ok {
      active: (> (get expiration subscription) block-height),
      expiration: (get expiration subscription)
    })
  )
)

;; Get current subscription price
(define-read-only (get-subscription-price)
  (ok (var-get subscription-price))
)

;; Initialize contract
(begin
  (var-set subscription-price u10)
)

