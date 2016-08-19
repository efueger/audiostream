class ScalesController < ApplicationController
  def index
    render locals: { scales: Scale.all }
  end

  def show
    scale = Scale.find(params[:id])
    # chord1 = Chord.first
    # chord2 = Chord.third
    key = Key.first
    reverb = Reverb.first
    piano_notes = []
    harp_notes = []
    all_notes = Note.all
    notes = notes_in_key_and_scale(key.name, scale)
    
    all_notes.group_by(&:instrument)

    all_notes.each_with_index do |note, index|
      if notes.include?(note.name) && note.instrument.name == "piano"
        piano_notes << note
      end
      if notes.include?(note.name) && note.instrument.name == "harp"
        harp_notes << note
      end
    end
    render locals: { piano_notes: piano_notes, harp_notes: harp_notes, reverb: reverb }
  end
end
