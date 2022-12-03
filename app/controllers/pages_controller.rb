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
      }
    ]
  end
end
