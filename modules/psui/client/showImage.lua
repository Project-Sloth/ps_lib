local function showImage(imageUrl)
    SendNUIMessage({
        action = 'showImage',
        data = imageUrl
    })
    SetNuiFocus(true, true)
end

exports('showImage', showImage)
ps.exportChange('ps-ui', 'showImage', showImage)
RegisterCommand('testShowImage', function(source, args, rawCommand)
   exports['ps-ui']:showImage('https://i.ytimg.com/vi/ZyI7bOqaldg/maxresdefault.jpg')
   Wait(2000)
   exports['ps-ui']:showImage('https://media.tenor.com/nYAbPZ6Im4YAAAAM/uwu-cute.gif')
   Wait(2000)
   exports['ps-ui']:showImage('https://wallpapers-clan.com/wp-content/uploads/2022/11/meme-gif-pfp-20.gif')
end, false)