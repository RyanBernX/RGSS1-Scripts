#:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:
# Dynamic Gardening
# Author: ForeverZer0
# Date: 5.13.2011
# Version: v.3.0
#:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:
#                            VERSION HISTORY
#:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:
#  v.1.1  (4.15.2010)
#   - Improved coding 
#   - No longer uses game variables, events use self-switches instead
#   - Added ability to create different graphics for every plant, without
#     having to use more event pages
#   - Much less tedious setting up multiple events and changing the every 
#     condition variable.
#  v.2.0  (10.10.2010)
#   - Total re-write. Code has been vastly improved and is much more efficient.
#   - Event setup has been simplified. Now requires only a single comment, and 
#     does not require multiple pages.
#   - Added configurability for the number of stages each item requires.
#   - The timers no longer use Game_System to constantly update, but simply
#     compare themselves with the Graphics.frame_count when the event exists
#     on the current map, which also allows the plants to grow during scenes
#     other than Scene_Map and Scene_Battle.
#   - Got rid of Scene_Harvest. Scene_Garden now handles both aspects, and has
#     been improved.
#   - Added item icons to the help window display.
# v.3.0  (5.13.2011)
#   - Restructured code completely 
#   - Increased compatibility and performance
#   - Fixed bug with final graphic not behaving correctly
#:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:
#
# Explanation:
#
#   This system allows the player to plant seeds, which will eventually grow 
#   into plants that can be harvested for items. The system is very similar in
#   nature to that found in Legend of Mana. Seed's can be combined in different
#   ways, which will effect the total growth duration, the number of stages the
#   plant passes through, the graphics used, and of course the final result.
#
# Features:
#
#  - Totally configurable growth rates, results, and graphics for every plant.
#  - Can use arrays of items for each result, so the final item is not
#    neccessarily the same every time.
#  - Each plant timer is independent, and its progress is saved with the game.
#  - Easy setup. Need only a single comment in one of the event's pages.
#
# Instructions:
#   
#  - Place script below Debug and above Main
#  - Configure the options below (instructions are with each setting)
#  - Create an event, setting the graphic to whatever you want. This will be the
#    graphics used when nothing is growing on the plant.
#  - At the very top event's page, place a comment that reads "Garden Event", 
#    omitting the quotation marks.
#  - As long as the page's conditions are met, this event can be clicked on to
#    initiate the Garden scene, and can grow plants.
#  - Note that plants can be harvested early, but they will yield nothing until 
#    they are ripe.
#
#:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
#  BEGIN CONFIGURATION
#:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
 
#===============================================================================
# ** Garden
#===============================================================================
 
module Garden
 
  SEED_IDS = [524, 525, 526, 527, 528, 529, 530, 531]
  # IDs of the items in the database that are seeds. Add them into the array in
  # the order of value/rarity in your game
 
  HARVEST_SE = '056-Right02'
  # This is the SE that will be played when the player harvests the plant.
 
  SEED_DISPLAY = true
  # If true, all seeds will be displayed in the seed window, including those 
  # that the player does not have, though they will be disabled. If false, only
  # seeds that that the player currently has will be displayed.
 
  # Define the growth rates here. (the average of both seeds will be used)
  def self.growth_rate(seed)
    return case seed
    # when SEED_ID then SECONDS
    when 524 then 30
    when 525 then 40
    when 526 then 50
    when 527 then 60
    when 528 then 70
    when 529 then 80 
    when 530 then 90
    when 531 then 100
    end
  end
 
#-------------------------------------------------------------------------------
# Define the number of stages that each item uses. The stages will still cycle
# in the same order, but only use up to the defined number of them before going
# to the final graphic. This will not effect the duration that the seed takes to 
# grow, only how many times the graphic changes.
# 
# You do not have to define anything that uses a three stage configuration.
#-------------------------------------------------------------------------------
  def self.number_stages(result)
    case result
    when 640,538,278,279,282,280,10,6
      return 4
    when 258,259,260,261,262,263,304,535,536
      return 5
    else
      return 3
    end
  end
 
 
#-------------------------------------------------------------------------------
# Define the final result of the seeds. A random item from the array will be
# given as the final result.
#  
# Each seed is given a value from 0 to the total number of seeds in the SEED_IDS
# array, and both values are added together to determine which 'produce' array
# will be used for the final result. This is why it is important that you have 
# the SEED_IDS array in order of value/rarity. You can find the total number of 
# cases you will need by subtracting 1 from the total number of different seeds 
# in SEED_IDS, and multiplying that number by 2.
#
#   EX. Player uses one each of the first and last seed in the SEED_IDS array,
#       and there are 8 total seeds in the array...
#
#       FIRST_SEED = 2
#       LAST_SEED = 5         2 + 5 = RESULT
#
# By placing multiple copies of the same value in an array, you can increase
# the odds of receiving that item over another in the same array.
#-------------------------------------------------------------------------------
 
  def self.produce(seed)
    return case seed 
    when 0 then [278, 279]      # Only if both seed are the lowest seeds
    when 1 then [279, 282]
    when 2 then [282, 280]
    when 3 then [280, 538]
    when 4 then [538, 10]
    when 5 then [10, 6]
    when 6 then [6, 258]      # Every combination in between
    when 7 then [258, 259]
    when 8 then [259, 260]
    when 9 then [260, 261]
    when 10 then [261, 262]
    when 11 then [262, 263]
    when 12 then [263, 304]
    when 13 then [304, 535]
    when 14 then [536]         # Only if both seeds are the highest seeds
    end
  end
 
#------------------------------------------------------------------------------- 
#  Define graphics for the final results, and each stage. Follow the below 
#  template to set it up.
#
#   when ITEM_ID/STAGE then ['FILENAME', X, Y]
#
#   ITEM_ID = The ID number of the item in your database
#   STAGE = The stage during which to display the graphic
#
#   FILENAME = The name of the character file the needed graphic is on
#   X = The x-coordinate of the correct picture on the charset (1 - 4)
#   Y = The y-coordinate of the correct picture on the charset (1 - 4)
#
#           ← X →             Ex.   If the needed graphic was in the bottom
#         1  2  3  4                left corner:   X = 1    Y = 4 
#       ┌──┬──┬──┬──┐                    
#     1 │  │  │  │  │
#       ├──┼──┼──┼──┤
#  ↑  2 │  │  │  │  │
#  Y    ├──┼──┼──┼──┤
#  ↓  3 │  │  │  │  │
#       ├──┼──┼──┼──┤
#     4 │  │  │  │  │
#       └──┴──┴──┴──┘
#-------------------------------------------------------------------------------
 
  def self.stage_graphics(stage)
    return case stage
    when 0 then ['Plants1', 1, 1]
    when 1 then ['Plants1', 2, 3]
    when 2 then ['Plants1', 2, 1]
    when 3 then ['Plants1', 4, 2]
    when 4 then ['Plants1', 2, 4]
    end
  end
 
  def self.final_graphic(item)
    return case item   
    when 283 then  ['Garden Plants', 4, 4]
    when 278 then ['Garden Plants', 4, 1]
    when 279 then ['Garden Plants', 4, 2]
    when 482 then ['Garden Plants', 4, 3]
    when 280 then ['Garden Plants', 1, 1]   
    when 10 then ['Garden Plants', 1, 4]
    when 6 then ['Garden Plants', 2, 1]
    when 258 then ['Garden Plants', 2, 4]
    when 259 then ['Garden Plants', 1, 2]
    when 260 then ['Garden Plants', 2, 2]
    when 261 then ['Garden Plants', 2, 3]
    when 262 then ['Garden Plants', 1, 3]
    when 263 then ['Garden Plants', 3, 3]
    when 534 then ['Garden Plants', 3, 2]
    when 535 then ['Garden Plants', 3, 1]
    when 536 then ['Garden Plants', 3, 4]
    end
  end
 
#:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
#  END CONFIGURATION
#:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
 
  def self.plant_seeds(seed1, seed2, event_id)
    # Create a new instance of a Garden::Plant
    plant = self::Plant.new(event_id, seed1, seed2)
    if $game_system.garden[$game_map.map_id] == nil
      $game_system.garden[$game_map.map_id] = [plant]
    else
      $game_system.garden[$game_map.map_id].push(plant)
    end
  end
 
  def self.harvest(id)
    # Find the appropriate plant.
    plant = $game_system.garden[$game_map.map_id].find {|plant| plant.id == id }
    return nil if plant == nil
    # Return the result, and delete plant data from array.
    result = plant.produce
    plant.restore_event
    $game_system.garden[$game_map.map_id] -= [plant]
    return result
  end
 
#===============================================================================
# ** Garden::Plant
#===============================================================================
 
  class Plant
 
    attr_reader :id, :ripe
 
    def initialize(id, seed1, seed2)
      # Initialize needed instance variables.
      @id, @seed1, @seed2 = id, seed1, seed2 
      @ripe, @stage = false, -1
      # Run setup method, using data in Garden config for this plant's seeds
      setup
    end
 
    def setup
      # Store original graphic, direction, and pattern in variable.
      event = $game_map.events[@id]
      @original_event = [event.character_name, event.direction, event.pattern]
      # Calculate the total duration of the seed combination.
      @duration = (Garden.growth_rate(@seed1) + Garden.growth_rate(@seed2)) 
      # Find the produce that this combination will grow into
      comb = Garden::SEED_IDS.index(@seed1) + Garden::SEED_IDS.index(@seed2)
      @produce = Garden.produce(comb)
      @produce = @produce[rand(@produce.size)]
      # Get the number of stages this plant will use, then setup counts for it
      number, count = Garden.number_stages(@produce), 0
      dur = (@duration / number.to_f).to_i
      @stages = (0...number).to_a 
      @stages.collect! {|i| $game_system.garden_counter + (i * dur) }
      # Refresh the plant to apply changes
      refresh
    end
 
    def refresh
      unless @ripe 
        # Initialize local variable that will determine if graphic needs redrawn.
        previous = @stage
        count = @stages.find_all {|rate| $game_system.garden_counter <= rate }
        @stage = (@stages.size - count.size)
        @ripe = (@stage >= @stages.size - 1) 
        # Redraw bitmap if needed.
        change_graphic(@ripe) if previous != @stage
      end
    end
 
    def change_graphic(final)
      # Set local variable to this plant's event
      event = $game_map.events[@id]
      data = final ? Garden.final_graphic(@produce) : 
        Garden.stage_graphics(@stage)
      # Apply graphical change by simply altering event's stance and source 
      event.character_name = data[0]
      event.direction = (2 * data[2])
      event.pattern = (data[1] - 1)
      event.refresh
    end
 
    def restore_event
      # Restore event to original state before planting.
      event = $game_map.events[@id]
      event.character_name = @original_event[0]
      event.direction = @original_event[1]
      event.pattern = @original_event[2]
    end
 
    def produce
      # Return nil if not yet ripe, else return an item ID.
      return (@ripe ? @produce : nil)
    end
  end
end
 
#===============================================================================
# ** Game_System
#===============================================================================
 
class Game_System
 
  attr_accessor :garden, :garden_counter
 
  alias zer0_garden_init initialize
  def initialize
    # Initialize variables used for the garden system.
    @garden_counter = 0
    @garden = {}
    zer0_garden_init
  end
 
  alias zer0_garden_upd update
  def update
    # Increase garden counter and check if update is needed every second.
    if (Graphics.frame_count % 40) == 0
      @garden_counter += 1
      # Check if current map has any plants on it. If so, refresh them.
      if @garden[$game_map.map_id] != nil && !@garden[$game_map.map_id].empty?
        @garden[$game_map.map_id].each {|plant| plant.refresh }
      end
    end
    zer0_garden_upd
  end
end
 
#===============================================================================
# ** Game_Event
#===============================================================================
 
class Game_Event
 
  attr_accessor :character_name, :direction, :pattern
 
  alias zer0_garden_event_refresh refresh
  def refresh
    # Normal refresh method.
    zer0_garden_event_refresh
    # Set flag for this event being a garden event.
    @garden_event = (@page != nil && @page.list[0].code == 108 &&
      @page.list[0].parameters[0] == 'Garden Event')
  end
 
  alias zer0_garden_upd update
  def update
    # Skip update method foe this event if it is a plant.
    @garden_event ? return : zer0_garden_upd
  end
 
  alias zer0_garden_event_start start
  def start
    # Redefine the 'start' method if Garden Event flag is present.
    if @garden_event 
      plants, harvest = $game_system.garden[$game_map.map_id], false
      # Check if plant exists, and if so check if it is ripe.
      pick = plants != nil ? (plants.find {|obj| obj.id == @id }) != nil : false
      $scene = Scene_Garden.new(@id, pick)
    else
      zer0_garden_event_start
    end
  end
end
 
#===============================================================================
# ** Game_Map
#===============================================================================
 
class Game_Map
 
  alias zer0_garden_setup setup
  def setup(map_id)
    zer0_garden_setup(map_id)
    # Refresh each plant when map is set up
    if $game_system.garden[@map_id] != nil
      $game_system.garden[@map_id].each {|obj| obj.change_graphic(obj.ripe) }
    end
  end
end
 
#===============================================================================
# * Window_Seed
#===============================================================================
 
class Window_Seed < Window_Selectable
 
  def initialize
    super(160, 304, 320, 160)
    self.index = 0
    refresh
  end
 
  def refresh
    # Clear the bitmap.
    self.contents = self.contents.dispose if self.contents != nil
    # Determine what seeds to display.
    @seeds = Garden::SEED_IDS.collect {|id| $data_items[id] }
    unless Garden::SEED_DISPLAY
      @seeds.reject! {|seed| $game_party.item_number(seed.id) < 1 }
    end
    @item_max = @seeds.size
    # Draw the items on the bitmap.
    if @item_max > 0
      self.contents = Bitmap.new(width - 32, @item_max * 32)
      @seeds.each_index {|i|
        item = @seeds[i]
        number = $game_party.item_number(item.id)
        self.contents.font.color = number > 0 ? normal_color : disabled_color
        opacity = number > 0 ? 255 : 128
        # Find icon bitmap and set it to window, and draw the text.
        bitmap = RPG::Cache.icon(item.icon_name)
        self.contents.blt(4, i*32+4, bitmap, Rect.new(8, 11, 48, 48), opacity)
        self.contents.draw_text(38, i*32, 288, 32, item.name)
        self.contents.draw_text(-32, i*32, 288, 32, ':', 2)
        self.contents.draw_text(-4, i*32, 288, 32, number.to_s, 2)
      }
    end
  end
 
  def seed
    # Returns currently highlighted seed item.
    return @seeds[self.index]
  end
end
 
#===============================================================================
# * Scene_Garden
#===============================================================================
 
class Scene_Garden
 
  def initialize(id, harvest)
    @event_id, @harvest = id, harvest
    # Play SE to give impression that scene never changed.
    $game_system.se_play($data_system.decision_se)
    $game_player.straighten
    garden = $game_system.garden[$game_map.map_id]
    if garden != nil
      @plant = garden.find {|plant| plant.id == id }
    end
  end
 
  def main 
    # Create map sprite and required windows.
    @map, @help_window = Spriteset_Map.new, Window_Help.new
    # Create Confirmation window.
    @confirm_window = Window_Command.new(128, ['是', '否'])
    @confirm_window.x, @confirm_window.y = 496, 336
    # Initialize sprites array. Used to handle all the sprites together.
    @sprites = [@map, @help_window, @confirm_window]
    # Create seed window if plant is not being harvested.
    unless @harvest
      @seed_window = Window_Seed.new
      @sprites.push(@seed_window)
      @seed_window.active = @seed_window.visible = false
      @help_window.set_text('很肥沃的土地，要进行种植吗？')
    else
      @data = $game_system.garden[$game_map.map_id][@event_id]
      if @plant != nil && @plant.ripe
        text = '作物已经成熟，要进行收获吗？'
      else
        text = '作物还没有完全成熟，要提前进行收获吗？'
      end
      @help_window.set_text(text)
    end
    # Transition instantly then start main loop.
    Graphics.transition(0)
    loop { Graphics.update; Input.update; update; break if $scene != self }
    # Dispose of all the sprites.
    @sprites.each {|sprite| sprite.dispose }
    # Have map refresh to update any changes made.
    $game_map.need_refresh = true
  end
 
  def update
    @sprites.each {|sprite| sprite.update }
    # Branch update method depending on what window is active.
    if @confirm_window.active
      update_confirm
    elsif @seed_window != nil && @seed_window.active
      update_seed_select
    end
  end
 
  def update_confirm
    if Input.trigger?(Input::B)
      # Branch by what action is being canceled.
      if @harvest
        back_to_map
      else
        @seed1 == nil ? back_to_map : cancel_seed_selection
      end
    elsif Input.trigger?(Input::C)
      # Branch by what action is being confirmed.
      if @harvest
        if @confirm_window.index == 0
          item_id = Garden.harvest(@event_id)
          if item_id != nil
            @confirm_window.active = @confirm_window.visible = false
            # Gain item, play the harvest SE, then return to the map.
            $game_party.gain_item(item_id, 1)
            $game_system.se_play(RPG::AudioFile.new(Garden::HARVEST_SE, 80, 100))
            show_results($data_items[item_id])
            $scene = Scene_Map.new
          else
            back_to_map
          end
        else
          back_to_map
        end
      else
        # If asking if player would like to plant seeds at this location.
        if @seed1 == nil
          if @confirm_window.index == 0
            @seed_window.active = @seed_window.visible = true
            @confirm_window.active = @confirm_window.visible = false
            @help_window.set_text('请选择您喜欢的种子，进行种植')
          else
            back_to_map
            return
          end
        else # If confirming seed selection.
          if @confirm_window.index == 0
            # Plant seeds and return to map.
            Garden.plant_seeds(@seed1.id, @seed2.id, @event_id)
            $scene = Scene_Map.new
          else # If canceling seed selection
            cancel_seed_selection
            return
          end
        end
        $game_system.se_play($data_system.decision_se)
      end
    end
  end
 
  def show_results(result)
    @help_window.contents.clear
    # Display the message in the help window.
    @help_window.draw_item_name(result, 0, 0)
    cw = @help_window.contents.text_size(result.name).width + 32
    @help_window.contents.draw_text(cw, 0, 608, 32, ' 已添加至您的背包!')
    # Call Input.update to the clear key press.
    Input.update
    # Loop until it is pressed again.
    until Input.trigger?(Input::C)
      Graphics.update; Input.update; update
    end
  end
 
  def cancel_seed_selection
    # Play cancel SE, reset seeds, and activate/deactivate windows.
    $game_system.se_play($data_system.cancel_se)
    @seed_window.active = @seed_window.visible = true
    @confirm_window.active = @confirm_window.visible = false
    @help_window.set_text('请选择您喜欢的种子，进行种植')
    @seed1 = @seed2 = nil
  end
 
  def back_to_map
    # Play cancel SE and return to map.
    $game_system.se_play($data_system.cancel_se)
    $scene = Scene_Map.new
  end
 
  def update_seed_select
    if Input.trigger?(Input::B)
      # If first seed is selected, go back to re-select, else return to map.
      if @seed1 != nil
        $game_party.gain_item(@seed1.id, 1)
        @seed1 = nil
        @seed_window.refresh
        $game_system.se_play($data_system.cancel_se)
      else
        back_to_map
      end
    elsif Input.trigger?(Input::C)
      # Play Cancle SE if displayed and party has none.
      if $game_party.item_number(@seed_window.seed.id) < 1
        $game_system.se_play($data_system.buzzer_se)
        return
      end
      $game_system.se_play($data_system.decision_se)
      # Set first seed if not defined, else set the second seed and continue.
      if @seed1 == nil
        @seed1 = @seed_window.seed
        $game_party.lose_item(@seed1.id, 1)
      else
        @seed2, @seed_window.active = @seed_window.seed, false
        $game_party.lose_item(@seed2.id, 1)
        @confirm_window.active = @confirm_window.visible = true
      end
      # Refresh seed window to show changes in inventory.
      set_help
      @seed_window.refresh
    end
  end
 
  def set_help
    # Clear help window.
    @help_window.contents.clear
    # Draw items
    text = @seed2 != nil ? '确定以它们进行种植吗？' : '请选择第二类种子'
    @help_window.set_text(text)
    @help_window.draw_item_name(@seed1, 224, 0)
    if @seed2 != nil
      cw = @help_window.contents.text_size(@seed1.name).width + 320
      @help_window.draw_item_name(@seed2, cw, 0)
    end
  end
end
