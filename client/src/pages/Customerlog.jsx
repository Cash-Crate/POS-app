import image from '../../public/CashCrateLogo.webp'
import search from '../../public/search.svg'

const CustomerLogs = () => {
    return (
      <main className="h-screen ">
            <div className="flex flex-row h-full">
                <aside className='flex flex-col p-5 border border-black justify-between'>{/* sidebar */}
                    <div className='flex flex-col gap-10'>
                        <img src={image} alt="Cash Crate Logo" className="aspect-square w-full"/>
                        <ul className='flex flex-col gap-5 text-black'>
                            <li className='text-xl'>Dashboard</li>
                            <li className='text-xl'>Logs</li>
                            <li className='text-xl'>Documentation</li>
                        </ul>
                    </div>
                    <div className='self-center pb-5'>
                        <a href="" className='text-xl underline'>Sign In</a>
                    </div>
                </aside>
                <section className='w-full p-5'>
                    <header className='flex flex-col w-full gap-5'>
                    <div className='flex justify-center'>
                        <div className='flex flex-row gap-2 btn-dark py-2.5 px-2.5 w-[50%] rounded-3xl'>
                            <img src={search} alt="search-icon" className="aspect-square h-5"/>
                            <input id="search" className="btn-dark w-full outline-none" type="search" name="search-bar" placeholder="Search"></input>
                        </div>
                    </div>
                        <ul className='flex flex-row gap-2.5 items-center'>
                            <li><button className='btn-highlight py-2.5 w-40 rounded-lg'>Customer Logs</button></li>
                            <li><button className='btn-dark py-2.5 w-40 rounded-lg'>Action Logs</button></li>
                        </ul>
                    </header>
                    <div>
                        
                    </div>
                </section>
            </div>
      </main>
    );
  };
  
  export default CustomerLogs;
  