# Wilber

Your friendly assistant.

Wilber -- named after the famous GIMP mascot -- is a simple, user-friendly assistant application designed to help you manage your tasks and reminders efficiently. It features a clean interface and integrates seamlessly with the GNOME desktop environment.

## Building and running the app

```sh
# Build
flatpak-builder --user --install --sandbox --force-clean ./build/ ./com.cathive.Wilber.json

# Run
G_MESSAGES_DEBUG=all \
flatpak run --user com.cathive.Wilber
```
