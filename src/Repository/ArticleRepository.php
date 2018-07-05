<?php

namespace App\Repository;

use App\Entity\Article;
use App\Entity\Tag;
use Doctrine\Bundle\DoctrineBundle\Repository\ServiceEntityRepository;
use Symfony\Bridge\Doctrine\RegistryInterface;

/**
 * @method Article|null find($id, $lockMode = null, $lockVersion = null)
 * @method Article|null findOneBy(array $criteria, array $orderBy = null)
 * @method Article[]    findAll()
 * @method Article[]    findBy(array $criteria, array $orderBy = null, $limit = null, $offset = null)
 */
class ArticleRepository extends ServiceEntityRepository
{
    public function __construct(RegistryInterface $registry)
    {
        parent::__construct($registry, Article::class);
    }

//    /**
//     * @return Article[] Returns an array of Article objects
//     */
    /*
    public function findByExampleField($value)
    {
        return $this->createQueryBuilder('a')
            ->andWhere('a.exampleField = :val')
            ->setParameter('val', $value)
            ->orderBy('a.id', 'ASC')
            ->setMaxResults(10)
            ->getQuery()
            ->getResult()
        ;
    }
    */

    /*
    public function findOneBySomeField($value): ?Article
    {
        return $this->createQueryBuilder('a')
            ->andWhere('a.exampleField = :val')
            ->setParameter('val', $value)
            ->getQuery()
            ->getOneOrNullResult()
        ;
    }
    */
    //找前一篇文章
    public function findOnePrevArticle($id)
    {
        return $this->createQueryBuilder('a')
            ->andWhere('a.id < :id')
            ->setParameter('id',$id)
            ->orderBy('a.id','DESC')
            ->select('a.id,a.title')
            ->setMaxResults(1)
            ->getQuery()
            ->getOneOrNullResult();
    }
    //找后一篇文章
    public function findOneNextArticle($id)
    {
        return $this->createQueryBuilder('a')
            ->andWhere('a.id > :id')
            ->setParameter('id',$id)
            ->orderBy('a.id','ASC')
            ->select('a.id,a.title')
            ->setMaxResults(1)
            ->getQuery()
            ->getOneOrNullResult();
    }
    //通过标签名字找文章
    public function dd($name)
    {
        $query = $this->getEntityManager()
            ->createQuery('
                SELECT p, t
                FROM App:Article p                
                LEFT JOIN p.tags t
               WHERE t.name =:name
            ')->setParameter('name',$name);
        return  $query;
    }
    //最新的10篇文章
    public function getLastest($num)
    {
        return $this->createQueryBuilder('a')
            ->orderBy('a.id','DESC')
            ->setMaxResults($num)
            ->select('a.id,a.title')
            ->getQuery()
            ->getResult();
    }
}
