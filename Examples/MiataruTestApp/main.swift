import Foundation
import MiataruAPIClient
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif
import Dispatch
import _Concurrency

// Global flag to stop the loop
var shouldTerminate = false

// Signal handler for SIGINT (CTRL+C)
signal(SIGINT) { _ in
    print("\nSIGINT received, stopping...", terminator: "\n")
    fflush(stdout)
    shouldTerminate = true
}

struct MiataruTestApp {
    static func main() async {
        let serverURL = URL(string: "https://service.miataru.com")!
        let testDeviceID = "BF0160F5-4138-402C-A5F0-DEB1AA1F4216"
        let testPostDeviceID = "test-post-device-id"

        while !shouldTerminate {
            // Generate a random location
            let longitude = Double.random(in: -180...180)
            let latitude = Double.random(in: -90...90)
            let accuracy = Double.random(in: 5...100)
            let timestamp = String(Int(Date().timeIntervalSince1970))
            let updatePayload = UpdateLocationPayload(
                Device: testPostDeviceID,
                Timestamp: timestamp,
                Longitude: longitude,
                Latitude: latitude,
                HorizontalAccuracy: accuracy
            )
            do {
                print("Sending random location: \(latitude), \(longitude) (accuracy: \(accuracy))")
                fflush(stdout)
                let ack = try await MiataruAPIClient.updateLocation(
                    serverURL: serverURL,
                    locationData: updatePayload,
                    enableHistory: true,
                    retentionTime: 30
                )
                print("UpdateLocation ACK: \(ack)")
                fflush(stdout)
            } catch {
                print("Failed to send location: \(error)")
                fflush(stdout)
            }
            do {
                print("Starting GetLocation test...")
                fflush(stdout)
                let locations = try await MiataruAPIClient.getLocation(
                    serverURL: serverURL,
                    forDeviceIDs: [testDeviceID],
                    requestingDeviceID: testPostDeviceID
                )
                print("GetLocation result:")
                for loc in locations {
                    print(loc)
                }
            } catch {
                print("Failed to fetch location: \(error)")
            }
            if shouldTerminate {
                break
            }
            print("Waiting 5 seconds before next request...")
            fflush(stdout)
            try? await Task.sleep(nanoseconds: 5_000_000_000)
        }
        print("Program finished.")
    }
}

let group = DispatchGroup()
group.enter()
Task {
    await MiataruTestApp.main()
    group.leave()
}
group.wait() 