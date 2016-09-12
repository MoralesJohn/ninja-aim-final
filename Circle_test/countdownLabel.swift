import SpriteKit
class CountdownLabel: SKLabelNode {
    var endTime: NSDate!
    func update(){
        let timeLeftInteger = Int(timeLeft())
        text = String(timeLeftInteger)
        fontName = "Score"
    }
    
    func startWithDuration(duration: NSTimeInterval){
        let timeNow = NSDate()
        endTime = timeNow.dateByAddingTimeInterval(duration)
    }
    
    private func timeLeft() -> NSTimeInterval{
        let now = NSDate()
        let remainingSeconds = endTime.timeIntervalSinceDate(now)
        return max(remainingSeconds, 0)
    }
    
    func hasFinished() -> Bool {
        return timeLeft() == 0
    }
}