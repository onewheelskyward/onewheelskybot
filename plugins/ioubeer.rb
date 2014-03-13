require 'data_mapper'
require 'dm-postgres-adapter'
require_relative '../models/iou'

class IOUBeer
  include Cinch::Plugin

  #listen_to :message, :method => :on_connect
  match /ious(\s+([^\s]+)|)/i, method: :show_ious
  match /iou\s+([^\s]+)/i, method: :add_iou
# This is going to be completely abused.  :)
#  match /uome\s+([^\s]+)/i, method: :add_uome

  set :help, <<-EOF
!iou [nick] Owe nick a beer
!ious Show owed beers
Thanks to @incanus77 for the iou idea.
  EOF

  def add_iou(msg, query)
    ower = msg.user.name
    owee = query
    IOU.create(ower: ower, owee: owee, channel: msg.channel)
    msg.reply "#{ower} now owes #{owee} one #{beer_icons 1}."
  end

  def add_uome(msg, query)
    owee = msg.user.name
    ower = query
    IOU.create(ower: ower, owee: owee, channel: msg.channel)
    msg.reply "#{ower} now owes #{owee} one #{beer_icons 1}."
  end

  def beer_icons(count)
    str = ''
    0..count.times do
      str += "🍺"
    end
    str
  end

  # ow about '<person> is owed x beers by ubercolin, y beers by status, etc for a total of z beers'?
  def show_ious(msg, query)
    query.strip!
    if query != ''
      ious = IOU.all(owee: msg.user.name, ower: query)
      msg.reply "#{query} owes #{msg.user.name} #{beer_icons ious.count}."
    else
      user_ious = {}
      total_beers = 0

      ious = IOU.all(owee: msg.user.name, order: [:ower], status: :owed)

      ious.each do |iou|
        if user_ious[iou.ower].nil?
          user_ious[iou.ower] = 0
        end
        user_ious[iou.ower] += 1
        total_beers += 1
      end

      str = "#{msg.user.name} is owed "
      user_ious.each do |user, beers|
        str += "#{beers} beers by #{user}, "
      end

      str += "for a total of #{total_beers} beers."
      #users = ious.map { |i| "#{beer_icons IOU.count(owee: msg.user.name, ower: i.ower)} #{i.ower}" }
      #users.uniq!

      #"#{beer_icons ious.count} beers owed to #{msg.user.nick} by #{users.join ', '}"
      msg.reply str
    end

  end
end
