# MiataruAPIClient

Swift package for the Miataru API with a small example application.

## Package Version

`1.1.0` (API 1.1 support)

## Structure

- `Sources/MiataruAPIClient/` – Swift package (library)
- `Examples/MiataruTestApp/` – Example app and Dockerfile

## Add as Swift Package in Xcode

1. Open your Xcode project.
2. Choose **File > Add Packages...**
3. Use the local path or the Git repository URL.
4. Add the **MiataruAPIClient** product.
5. Import the package:
   ```swift
   import MiataruAPIClient
   ```

## API 1.1 Notes

- `RequestMiataruDeviceID` is mandatory for `getLocation` and `getLocationHistory`.
- Write operations and visitor history support `DeviceKey` authentication.
- New endpoints: `deleteLocation`, `setDeviceKey`, `setAllowedDeviceList`.

## Example Usage

```swift
let serverURL = URL(string: "https://service.miataru.com")!

let locations = try await MiataruAPIClient.getLocation(
    serverURL: serverURL,
    forDeviceIDs: ["device-id"],
    requestingDeviceID: "requesting-device-id"
)

let updated = try await MiataruAPIClient.updateLocation(
    serverURL: serverURL,
    locationData: UpdateLocationPayload(
        Device: "device-id",
        DeviceKey: "optional-device-key",
        Timestamp: "1735689600",
        Longitude: 8.5417,
        Latitude: 47.3769,
        HorizontalAccuracy: 15
    ),
    enableHistory: true,
    retentionTime: 30
)

_ = try await MiataruAPIClient.setDeviceKey(
    serverURL: serverURL,
    deviceID: "device-id",
    currentDeviceKey: nil,
    newDeviceKey: "new-device-key"
)
```

## Run the Example App Locally

```bash
cd Examples/MiataruTestApp
swift run
```

## Run the Example App with Docker (from repo root)

```bash
docker build -f Examples/MiataruTestApp/Dockerfile -t miataru-testapp .
docker run -it --rm miataru-testapp
```

## Notes

- The example app sends and reads test data from `https://service.miataru.com`.
- Update device IDs in `main.swift` as needed.