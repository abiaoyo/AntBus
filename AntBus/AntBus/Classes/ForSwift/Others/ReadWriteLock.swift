import Foundation

class ReadWriteLock {
    
    private var rwlock = pthread_rwlock_t()
    
    deinit {
        // 销毁读写锁
        pthread_rwlock_destroy(&rwlock)
    }
    
    init() {
        // 初始化读写锁
        pthread_rwlock_init(&rwlock, nil)
    }

    func lock_read() {
        // 锁定读锁
        pthread_rwlock_rdlock(&rwlock)
    }
    
    func unlock_read() {
        // 解锁读锁
        pthread_rwlock_unlock(&rwlock)
    }
    
    func lock_write() {
        // 锁定写锁
        pthread_rwlock_wrlock(&rwlock)
    }
    
    func unlock_write() {
        // 解锁写锁
        pthread_rwlock_unlock(&rwlock)
    }
}
