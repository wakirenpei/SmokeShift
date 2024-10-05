import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = [ "currentDuration", "currentSavings", "totalDuration", "totalSavings", "sidebarTotalSavings", "indexCurrentSavings" ]
  static values = { 
    startDate: Number,
    dailySavings: Number,
    totalQuitSeconds: Number,
    totalSavings: Number,
    serverTime: Number
  }

  connect() {
    if (this.hasStartDateValue) {
      this.startDate = this.startDateValue
      this.initialTotalQuitSeconds = this.totalQuitSecondsValue
      this.initialTotalSavings = this.totalSavingsValue
      this.serverClientTimeDiff = Math.floor(Date.now() / 1000) - this.serverTimeValue
      this.updateTimer()
      this.timer = setInterval(() => this.updateTimer(), 1000)
    }
  }

  disconnect() {
    if (this.timer) {
      clearInterval(this.timer)
    }
  }

  updateTimer() {
    const now = Math.floor(Date.now() / 1000) - this.serverClientTimeDiff
    const currentDuration = now - this.startDate
    const currentSavings = this.calculateSavings(currentDuration)
    const totalDuration = this.initialTotalQuitSeconds + (now - this.serverTimeValue)
    const additionalSavings = this.calculateSavings(now - this.serverTimeValue)
    const totalSavings = this.initialTotalSavings + additionalSavings

    this.updateTargetIfExists('currentDuration', this.formatDuration(currentDuration))
    this.updateTargetIfExists('currentSavings', `¥${Math.floor(currentSavings).toLocaleString()}`)
    this.updateTargetIfExists('totalDuration', this.formatDuration(totalDuration))
    this.updateTargetIfExists('totalSavings', `¥${Math.floor(totalSavings).toLocaleString()}`)
    this.updateTargetIfExists('sidebarTotalSavings', `¥${Math.floor(totalSavings).toLocaleString()}`)
    this.updateTargetIfExists('indexCurrentSavings', `¥${Math.floor(currentSavings).toLocaleString()}`)
  }

  updateTargetIfExists(targetName, value) {
    if (this[`has${targetName.charAt(0).toUpperCase() + targetName.slice(1)}Target`]) {
      this[`${targetName}Target`].textContent = value
    }
  }

  calculateDuration(now) {
    return Math.floor((now - this.startDate) / 1000)
  }

  calculateSavings(duration) {
    return (this.dailySavingsValue / 86400) * duration
  }

  formatDuration(seconds) {
    const days = Math.floor(seconds / 86400);
    seconds %= 86400;
    const hours = Math.floor(seconds / 3600);
    seconds %= 3600;
    const minutes = Math.floor(seconds / 60);
    seconds %= 60;

    const parts = [];
    if (days > 0) parts.push(`${days}日`);
    if (hours > 0) parts.push(`${hours}時間`);
    if (minutes > 0) parts.push(`${minutes}分`);
    if (seconds > 0) parts.push(`${Math.floor(seconds)}秒`);

    return parts.join(' ');
  }
}