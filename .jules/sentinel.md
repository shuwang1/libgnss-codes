## 2024-07-23 - Information Leakage in Resource Loading
**Vulnerability:** The library exposes internal file paths and system details through raw error interpolation in `catch` blocks when loading `.bin` resource files.
**Learning:** In Swift, `Data(contentsOf:)` throws system-level `NSError` objects that contain full absolute file paths and underlying file system codes, which can inadvertently leak environment structures when running in production or as a package dependency.
**Prevention:** Catch errors and log a generic failure message (e.g., `Failed to load resource`) without interpolating the raw `error` object.
