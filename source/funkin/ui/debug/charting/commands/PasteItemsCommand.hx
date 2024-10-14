package funkin.ui.debug.charting.commands;

import funkin.data.song.SongData.SongEventData;
import funkin.data.song.SongData.SongNoteData;
import funkin.data.song.SongDataUtils;
import funkin.data.song.SongDataUtils.SongClipboardItems;
import funkin.ui.debug.charting.ChartEditorState;

/**
 * A command which inserts the contents of the clipboard into the chart editor.
 */
@:nullSafety
@:access(funkin.ui.debug.charting.ChartEditorState)
class PasteItemsCommand implements ChartEditorCommand
{
  var targetTimestamp:Float;
  // Notes we added and removed with this command, for undo.
  var addedNotes:Array<SongNoteData> = [];
  var addedEvents:Array<SongEventData> = [];

  public function new(targetTimestamp:Float)
  {
    this.targetTimestamp = targetTimestamp;
  }

  public function execute(state:ChartEditorState):Void
  {
    var currentClipboard:SongClipboardItems = SongDataUtils.readItemsFromClipboard();

    if (currentClipboard.valid != true)
    {
      state.error('Failed to Paste', 'Could not parse clipboard contents.');
      return;
    }

    var stepEndOfSong:Float = Conductor.instance.getTimeInSteps(state.songLengthInMs);
    var stepCutoff:Float = stepEndOfSong - 1.0;
    var msCutoff:Float = Conductor.instance.getStepTimeInMs(stepCutoff);

    addedNotes = SongDataUtils.offsetSongNoteData(currentClipboard.notes, Std.int(targetTimestamp));
    addedNotes = SongDataUtils.clampSongNoteData(addedNotes, 0.0, msCutoff);
    addedEvents = SongDataUtils.offsetSongEventData(currentClipboard.events, Std.int(targetTimestamp));
    addedEvents = SongDataUtils.clampSongEventData(addedEvents, 0.0, msCutoff);
    var removedNotes = addedNotes.copy();

    state.currentSongChartNoteData = SongDataUtils.addNotes(state.currentSongChartNoteData, addedNotes);
    // SongNoteDataUtils.concatOverwrite(state.currentSongChartNoteData, addedNotes, removedNotes,
    // ChartEditorState.stackNoteThreshold);
    state.currentSongChartEventData = state.currentSongChartEventData.concat(addedEvents);
    state.currentNoteSelection = removedNotes.copy();
    state.currentEventSelection = addedEvents.copy();
    removedNotes = SongDataUtils.subtractNotes(removedNotes, addedNotes);

    state.saveDataDirty = true;
    state.noteDisplayDirty = true;
    state.notePreviewDirty = true;

    state.sortChartData();

    // FIXME: execute() is reused as a redo function so these messages show up even when not actually pasting
    if (addedNotes.length == 0) state.error('Paste Failed', 'All notes would overlap already placed notes.')
    else if (removedNotes.length > 0) state.warning('Paste Successful', 'However overlapping notes were ignored.');
    else
      state.success('Paste Successful', 'Successfully pasted clipboard contents.');
  }

  public function undo(state:ChartEditorState):Void
  {
    state.playSound(Paths.sound('chartingSounds/undo'));

    state.currentSongChartNoteData = SongDataUtils.subtractNotes(state.currentSongChartNoteData, addedNotes);
    state.currentSongChartEventData = SongDataUtils.subtractEvents(state.currentSongChartEventData, addedEvents);
    state.currentNoteSelection = [];
    state.currentEventSelection = [];

    state.saveDataDirty = true;
    state.noteDisplayDirty = true;
    state.notePreviewDirty = true;

    state.sortChartData();
  }

  public function shouldAddToHistory(state:ChartEditorState):Bool
  {
    // This command is undoable. Add to the history if we actually performed an action.
    return (addedNotes.length > 0 || addedEvents.length > 0);
  }

  public function toString():String
  {
    var currentClipboard:SongClipboardItems = SongDataUtils.readItemsFromClipboard();

    var len:Int = currentClipboard.notes.length + currentClipboard.events.length;

    if (currentClipboard.notes.length == 0) return 'Paste $len Events';
    else if (currentClipboard.events.length == 0) return 'Paste $len Notes';
    else
      return 'Paste $len Items';
  }
}
