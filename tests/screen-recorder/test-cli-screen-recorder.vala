using Peek;
using Peek.Recording;

class TestCliScreenRecorder : CliScreenRecorder {
  public bool stop_command_called { get; set; default = false; }

  public override void start_recording (RecordingArea area) throws RecordingError {
    is_recording = true;
    stop_command_called = false;
  }

  protected override void stop_recording () {
    stop_command_called = true;
  }
}

void test_cancel () {
  var recorder = new TestCliScreenRecorder ();
  bool recording_aborted_called = false;
  recorder.recording_aborted.connect ((reason) => {
    recording_aborted_called = true;
    assert (reason == null);
  });

  try {
    recorder.record (RecordingArea ());
  } catch (RecordingError e) {
    assert (false);
  }

  assert (recorder.is_recording);
  assert (!recorder.stop_command_called);

  recorder.cancel ();

  assert (!recorder.is_recording);
  assert (recorder.stop_command_called);
  assert (recording_aborted_called);
}

void main (string[] args) {
  Test.init (ref args);

  Test.add_func (
    "/screen-recorder/cli-screen-recorder/test_cancel",
    test_cancel);

  Test.run ();
}
