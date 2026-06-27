# Raider GE77HX audio recovery notes

Purpose:
- This file is for future troubleshooting, especially by an LLM or assistant.
- If the built-in speakers stop working again, do not start from scratch by assuming PipeWire routing is broken.
- In the June 2026 incident, the real fix was an embedded-controller power reset after software routing had already been proven correct.

Machine:
- MSI Raider GE77HX 12UHS / MS-17K5
- Realtek ALC274 internal audio, subsystem `1462:1399`
- NVIDIA HDMI audio is separate and works independently

Working baseline:
- Use PipeWire + WirePlumber with ALSA and Pulse compatibility enabled.
- Keep `snd-intel-dspcfg dsp_driver=1` so the internal codec uses the legacy HDA path.
- Volume hotkeys should use `wpctl`, not extra PulseAudio/PipeWire package binaries.
- Avoid stale user/system WirePlumber and ALSA overrides unless there is a specific reason.

Historical incident:
- Date: June 2026.
- Trigger pattern: the built-in speakers stopped working after HDMI monitor/audio changes.
- HDMI audio worked.
- Headphone/HDMI routing could be fixed in software.
- Built-in laptop speakers remained silent even when selected.

Software checks that were already done:
- HDMI and headphone routing were recoverable in software.
- Built-in speakers still stayed silent even when PipeWire routed to the Realtek sink.
- ALSA showed playback reaching the ALC274 codec, with the speaker DAC and pin active.
- Mixer controls were unmuted, EAPD was enabled, and the speaker pin was powered.
- Live `hda-verb` tests for common GPIO amp toggles and Realtek coefficient writes did not restore sound.
- No separate Cirrus/TI/Maxim/Realtek smart-amp device was visible over ACPI/I2C.

Do this early if symptoms match:
- Full embedded-controller power reset:
  1. Shut down completely.
  2. Unplug AC power.
  3. Disconnect HDMI and USB devices.
  4. Hold the power button for about 60 seconds.
  5. Wait briefly, reconnect AC, and boot.
- After this reset, built-in speaker audio returned.

Conclusion from the June 2026 fix:
- The speaker failure was most likely an EC/firmware latch-up rather than a normal PipeWire or ALSA routing issue.
- If it happens again after HDMI use, try the EC reset flow before changing audio config.
- If HDMI still works and `wpctl status` shows streams routed to `Built-in Audio Analog Stereo`, prioritize EC reset over repeated PipeWire/WirePlumber rewrites.
- Do not assume the speakers are physically dead until the EC reset has been tried.

Current policy:
- Built-in analog audio is the preferred/default sink.
- HDMI audio is intentionally lower priority so plugging HDMI should not automatically take over audio.
- `Super+A` toggles the default sink between built-in audio and HDMI when HDMI is present.
