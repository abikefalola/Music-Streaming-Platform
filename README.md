# Decentralized Music Streaming Platform

A blockchain-based music streaming service that empowers artists and listeners through decentralized technology.

## Table of Contents
- [Overview](#overview)
- [Architecture](#architecture)
- [Smart Contracts](#smart-contracts)
- [Getting Started](#getting-started)
- [Features](#features)
- [Development Roadmap](#development-roadmap)
- [Contributing](#contributing)
- [License](#license)

## Overview

This decentralized music streaming platform revolutionizes how music is distributed, consumed, and monetized. By leveraging blockchain technology, we create a transparent ecosystem where artists receive fair compensation, listeners access music without intermediaries, and rights management is automated and trustless.

### Mission
To create a fair, transparent, and decentralized music ecosystem that benefits all participants while protecting intellectual property rights.

## Architecture

The platform is built on a blockchain foundation with several interconnected smart contracts, decentralized storage, and a user-friendly frontend application.

### Core Components:
1. **Smart Contracts**: Ethereum-based contracts managing various platform functions
2. **Decentralized Storage**: IPFS for storing audio files and metadata
3. **Frontend Application**: Web and mobile interfaces for users to interact with the platform
4. **Indexing Layer**: For efficient content discovery and recommendation

## Smart Contracts

### 1. Artist Contract
Manages artist profiles, music uploads, and identity verification
- **Functions**:
    - `registerArtist(name, bio, wallet)`: Creates a new artist profile
    - `uploadTrack(title, genre, ipfsHash, licenseTerms)`: Adds a new music track
    - `editProfile(fields, newValues)`: Updates artist information
    - `getArtistMetrics()`: Returns performance analytics for the artist

### 2. Licensing Contract
Handles rights management and royalty distribution
- **Functions**:
    - `createLicense(trackId, terms, royaltyPercentage)`: Sets licensing terms for a track
    - `distributeRoyalties(trackId)`: Automatically splits payments among rights holders
    - `transferRights(trackId, newOwner, percentage)`: Transfers ownership rights
    - `getLicenseTerms(trackId)`: Returns the current license terms for a track

### 3. Playlist Contract
Manages user-created and curated playlists
- **Functions**:
    - `createPlaylist(name, description, isPublic)`: Creates a new playlist
    - `addToPlaylist(playlistId, trackId)`: Adds a track to a playlist
    - `sharePlaylist(playlistId, recipient)`: Shares a playlist with another user
    - `discoverPlaylists(genre, mood)`: Returns playlists matching criteria

### 4. Subscription Contract
Handles user subscriptions, payments, and access management
- **Functions**:
    - `subscribe(tier, duration)`: Initiates a new subscription
    - `processPayout()`: Distributes funds to artists based on listens
    - `cancelSubscription()`: Ends a user's subscription
    - `upgradeSubscription(newTier)`: Changes a user's subscription level

## Getting Started

### Prerequisites
- Ethereum wallet (MetaMask recommended)
- Node.js and npm
- Basic understanding of blockchain transactions

### Installation
1. Clone the repository:
   ```
   git clone https://github.com/yourorganization/decentralized-music-platform.git
   cd decentralized-music-platform
   ```

2. Install dependencies:
   ```
   npm install
   ```

3. Configure your environment:
   ```
   cp .env.example .env
   ```
   Then edit the `.env` file with your specific configuration

4. Deploy smart contracts:
   ```
   npx hardhat run scripts/deploy.js --network <your-network>
   ```

5. Start the frontend application:
   ```
   npm run start
   ```

## Features

### For Artists
- **Direct Monetization**: Receive payments directly from listeners
- **Transparent Analytics**: Access real-time data on streams, earnings, and listener demographics
- **Flexible Licensing**: Set custom licensing terms for each track
- **Community Building**: Engage directly with fans through the platform

### For Listeners
- **Fair Pricing**: Pay only for what you listen to
- **High-Quality Streaming**: Access lossless audio formats
- **Discovery Tools**: Find new music based on preferences
- **Playlist Creation**: Build and share personalized playlists
- **Support Artists**: Know that your subscription directly supports creators

## Development Roadmap

### Phase 1: Foundation (Q1-Q2 2025)
- Core smart contract development and testing
- Basic frontend interface
- IPFS integration for music storage
- Initial artist onboarding

### Phase 2: Enhancement (Q3-Q4 2025)
- Advanced recommendation algorithm
- Mobile application release
- Social features implementation
- Expanded payment options

### Phase 3: Scaling (Q1-Q2 2026)
- Layer 2 scaling solution integration
- Cross-chain compatibility
- Governance token launch
- Decentralized autonomous organization (DAO) formation

## Contributing

We welcome contributions from developers, artists, and music enthusiasts. Please see our [CONTRIBUTING.md](CONTRIBUTING.md) file for guidelines on how to participate.

### Development Environment
Instructions for setting up a local development environment are available in the [DEVELOPMENT.md](DEVELOPMENT.md) file.

## License

This project is licensed under the MIT License - see the [LICENSE.md](LICENSE.md) file for details.

---

*Disclaimer: This platform is in active development. Smart contracts should be audited before deployment to production environments.*
