<?php
/**
 * Created by PhpStorm.
 * User: mash
 * Date: 2018/7/2
 * Time: 18:36
 */
namespace  App\Controller\Admin;

use Symfony\Bundle\FrameworkBundle\Controller\Controller;
use Symfony\Component\Routing\Annotation\Route;
use Symfony\Component\HttpFoundation\Request;

use App\Form\CategoryType;
use App\Entity\Category as CategoryEntity;
/**
 * @Route("/admin/category")
 */
class Category extends  Controller
{
    /**
     * @Route("/index",name="category_index")
     */
    public function index()
    {
        $repository = $this->getDoctrine()->getRepository(CategoryEntity::class);
        $res = $repository->findAll();
        return $this->render('admin/category/index.html.twig',[
            'res'   =>  $res,
        ]);
    }
    /**
     * @Route("/add",name="category_add",methods={"GET","POST"})
     */
    public function add(Request $request)
    {
        $entityManager = $this->getDoctrine()->getManager();
        $category = new CategoryEntity();
        $form = $this->createForm(CategoryType::class,$category);
        $form->handleRequest($request);
        if($form->isSubmitted() && $form->isValid()){
            $category = $form->getData();
            $entityManager->persist($category);
            $entityManager->flush();
            return $this->redirectToRoute('category_index');
        }
        return $this->render('admin/category/add.html.twig',['form'=>$form->createView()]);
    }
}