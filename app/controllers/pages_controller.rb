class PagesController < ApplicationController
  def home
    @records = [
      {
        label: 'Sent messages',
        name: 'Alexander Profeit',
        value: 45
      },
      {
        label: 'Received Reactions',
        name: 'Yannis Fotiadis',
        value: 17
      },
      {
        label: 'Reacted to a Message',
        name: 'Steph',
        value: 69
      },
      {
        label: 'Mentioned',
        name: 'Pawsey',
        value: 420
      }
    ]
  end
end
